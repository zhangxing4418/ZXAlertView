//
//  ViewController.m
//  ZXAlertViewProject
//
//  Created by Ziv on 16/6/23.
//  Copyright © 2016年 Ziv. All rights reserved.
//

#import "ViewController.h"
#import "ZXAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (IBAction)showMessage:(UIButton *)sender {
	[ZXAlertView showMessageBoxWithTitle:@"title" message:@"message" cancelActionTitle:@"cancel" otherActionTitles:@[@"one", @"two"] actionHandler:^(NSInteger buttonIndex) {
		NSLog(@"%ld", buttonIndex);
	}];
}

- (IBAction)showInput:(UIButton *)sender {
	[ZXAlertView showInputBoxWithStyle:UIAlertViewStyleLoginAndPasswordInput title:@"title" message:@"message" configurationHandler:^(NSInteger inputIndex, UITextField *textField) {
		if (inputIndex == 1) {
			textField.secureTextEntry = YES;
		}
	} cancelActionTitle:@"cancel" otherActionTitles:@[@"one", @"two"] actionHandler:^(NSInteger buttonIndex, NSArray *textFields) {
		for (UITextField* textField in textFields) {
			NSLog(@"%@", textField.text);
		}
	}];
}


@end
