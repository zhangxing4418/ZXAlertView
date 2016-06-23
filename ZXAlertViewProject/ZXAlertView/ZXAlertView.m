//
// ZXAlertView.m
//
// Created by iphone development on 6/23/16.
//
//

#import "ZXAlertView.h"
#import <BlocksKit+UIKit.h>
#import <BlocksKit/NSObject+A2DynamicDelegate.h>
#import <UIViewController+PPTopMostController.h>

typedef NS_ENUM (NSInteger, InputBoxStyle) {
	InputBoxStylePlainTextInput,
	InputBoxStyleSecureTextInput,
	InputBoxStyleLoginAndPasswordInput
};

@implementation ZXAlertView

#pragma mark - Public

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
	[self showAlertWithTitle:title message:message cancelActionTitle:@"OK"];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissalHandler:(void (^)(void))dismissalHandler {
	[self showAlertWithTitle:title message:message cancelActionTitle:@"OK" cancelActionHandler:dismissalHandler];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle {
	[self showAlertWithTitle:title message:message cancelActionTitle:cancelActionTitle cancelActionHandler:nil];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle cancelActionHandler:(void (^)(void))cancelActionHandler {
	[self showMessageBoxWithTitle:title message:message cancelActionTitle:cancelActionTitle otherActionTitles:nil actionHandler:cancelActionHandler ? ^(NSInteger buttonIndex) {
		if (buttonIndex == -1) {
			cancelActionHandler();
		}
	} : nil];
}

+ (void)showConfirmWithTitle:(NSString *)title message:(NSString *)message dismissalHandler:(void (^)(void))dismissalHandler {
	[self showConfirmWithTitle:title message:message otherActionTitle:@"OK" otherActionHandler:dismissalHandler];
}

+ (void)showConfirmWithTitle:(NSString *)title message:(NSString *)message otherActionTitle:(NSString *)otherActionTitle otherActionHandler:(void (^)(void))otherActionHandler {
	[self showConfirmWithTitle:title message:message cancelActionTitle:@"Cancel" otherActionTitle:otherActionTitle otherActionHandler:otherActionHandler];
}

+ (void)showConfirmWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle otherActionTitle:(NSString *)otherActionTitle otherActionHandler:(void (^)(void))otherActionHandler {
	[self showMessageBoxWithTitle:title message:message cancelActionTitle:cancelActionTitle otherActionTitles:@[otherActionTitle] actionHandler:otherActionHandler ? ^(NSInteger buttonIndex) {
		if (buttonIndex == 0) {
			otherActionHandler();
		}
	} : nil];
}

+ (void)showMessageBoxWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle otherActionTitles:(NSArray *)otherActionTitles actionHandler:(void (^)(NSInteger buttonIndex))actionHandler {
	if (NSStringFromClass([UIAlertController class])) {
		UIViewController *this = [UIViewController topMostController];
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
		if (cancelActionTitle) {
			[alertController addAction:[UIAlertAction actionWithTitle:cancelActionTitle style:UIAlertActionStyleCancel handler:actionHandler ? ^(UIAlertAction *action) {
				actionHandler(-1);
			} : nil]];
		}
		for (NSString *otherButtonTitle in otherActionTitles) {
			[alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:actionHandler ? ^(UIAlertAction *action) {
				actionHandler([otherActionTitles indexOfObject:otherButtonTitle]);
			} : nil]];
		}
		[this presentViewController:alertController animated:YES completion:nil];
	}
	else {
		[UIAlertView bk_showAlertViewWithTitle:title message:message cancelButtonTitle:cancelActionTitle otherButtonTitles:otherActionTitles handler:actionHandler ? ^(UIAlertView *alertView, NSInteger buttonIndex) {
			actionHandler(buttonIndex - alertView.cancelButtonIndex - 1);
		} : nil];
	}
}

+ (void)showPlainInputBoxWithTitle:(NSString *)title message:(NSString *)message configurationHandler:(void (^)(UITextField *textField))configurationHandler dismissalHandler:(void (^) (UITextField *textField))dismissalHandler {
	[self showInputBoxWithStyle:UIAlertViewStylePlainTextInput title:title message:message configurationHandler:configurationHandler ? ^(NSInteger inputIndex, UITextField *textField) {
		if (inputIndex == 0) {
			configurationHandler(textField);
		}
	} : nil cancelActionTitle:@"Cancel" otherActionTitles:@[@"OK"] actionHandler:dismissalHandler ? ^(NSInteger buttonIndex, NSArray *textFields) {
		if (buttonIndex == 0) {
			dismissalHandler(textFields[0]);
		}
	} : nil];
}

+ (void)showInputBoxWithStyle:(UIAlertViewStyle)alertViewStyle title:(NSString *)title message:(NSString *)message configurationHandler:(void (^)(NSInteger inputIndex, UITextField *textField))configurationHandler cancelActionTitle:(NSString *)cancelActionTitle otherActionTitles:(NSArray *)otherActionTitles actionHandler:(void (^)(NSInteger buttonIndex, NSArray *textFields))actionHandler {
	if (NSStringFromClass([UIAlertController class])) {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
		if (alertViewStyle == UIAlertViewStylePlainTextInput || alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
			[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
				if (configurationHandler) {
					configurationHandler(0, textField);
				}
			}];
		}
		if (alertViewStyle == UIAlertViewStyleSecureTextInput || alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
			[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
				textField.secureTextEntry = YES;
				if (configurationHandler) {
					configurationHandler(1, textField);
				}
			}];
		}
		if (cancelActionTitle) {
			[alertController addAction:[UIAlertAction actionWithTitle:cancelActionTitle style:UIAlertActionStyleCancel handler:actionHandler ? ^(UIAlertAction *action) {
				actionHandler(-1, alertController.textFields);
			} : nil]];
		}
		for (NSString *otherButtonTitle in otherActionTitles) {
			[alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:actionHandler ? ^(UIAlertAction *action) {
				actionHandler([otherActionTitles indexOfObject:otherButtonTitle], alertController.textFields);
			} : nil]];
		}
		UIViewController *self = [UIViewController topMostController];
		[self presentViewController:alertController animated:YES completion:nil];
	}
	else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelActionTitle otherButtonTitles:nil];
		alertView.alertViewStyle = alertViewStyle;
		for (NSString *otherButtonTitle in otherActionTitles) {
			[alertView addButtonWithTitle:otherButtonTitle];
		}
		[alertView.bk_dynamicDelegate implementMethod:@selector(alertView:clickedButtonAtIndex:) withBlock:actionHandler ? ^void (UIAlertView *alertView, NSInteger buttonIndex) {
			NSMutableArray *textFields = [NSMutableArray array];
			if (alertViewStyle != UIAlertViewStyleDefault) {
				[textFields addObject:[alertView textFieldAtIndex:0]];
			}
			if (alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
				[textFields addObject:[alertView textFieldAtIndex:1]];
			}
			actionHandler(buttonIndex, [NSArray arrayWithArray:textFields]);
		} : nil];
		[alertView.bk_dynamicDelegate implementMethod:@selector(willPresentAlertView:) withBlock:^void (UIAlertView *alertView) {
			if (alertViewStyle == UIAlertViewStyleSecureTextInput) {
				[alertView textFieldAtIndex:0].secureTextEntry = YES;
			}
			if (alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
				[alertView textFieldAtIndex:1].secureTextEntry = YES;
			}
			if (configurationHandler) {
				if (alertViewStyle != UIAlertViewStyleDefault) {
					configurationHandler(0, [alertView textFieldAtIndex:0]);
				}
				if (alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
					configurationHandler(1, [alertView textFieldAtIndex:1]);
				}
			}
		}];
		alertView.delegate = alertView.bk_dynamicDelegate;
		[alertView show];
	}
}

@end
