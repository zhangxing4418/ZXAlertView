//
// ZXAlertView.h
//
// Created by iphone development on 6/23/16.
//
//

@import Foundation;
@import UIKit;
@import CoreLocation;

@interface ZXAlertView : NSObject

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissalHandler:(void (^)(void))dismissalHandler;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle cancelActionHandler:(void (^)(void))cancelActionHandler;
+ (void)showConfirmWithTitle:(NSString *)title message:(NSString *)message dismissalHandler:(void (^)(void))dismissalHandler;
+ (void)showConfirmWithTitle:(NSString *)title message:(NSString *)message otherActionTitle:(NSString *)otherActionTitle otherActionHandler:(void (^)(void))otherActionHandler;
+ (void)showConfirmWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle otherActionTitle:(NSString *)otherActionTitle otherActionHandler:(void (^)(void))otherActionHandler;
+ (void)showMessageBoxWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle otherActionTitles:(NSArray *)otherActionTitles actionHandler:(void (^)(NSInteger buttonIndex))actionHandler;

+ (void)showPlainInputBoxWithTitle:(NSString *)title message:(NSString *)message configurationHandler:(void (^)(UITextField *textField))configurationHandler dismissalHandler:(void (^) (UITextField *textField))dismissalHandler;
+ (void)showInputBoxWithStyle:(UIAlertViewStyle)alertViewStyle title:(NSString *)title message:(NSString *)message configurationHandler:(void (^)(NSInteger inputIndex, UITextField *textField))configurationHandler cancelActionTitle:(NSString *)cancelActionTitle otherActionTitles:(NSArray *)otherActionTitles actionHandler:(void (^)(NSInteger buttonIndex, NSArray *textFields))actionHandler;

@end
