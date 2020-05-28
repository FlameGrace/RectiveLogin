//
//  LoginView.h
//  DemoProject
//
//  Created by Flame Grace on 2020/5/27.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (strong, nonatomic) UITextField *phoneNumberTextField;
@property (strong, nonatomic) UITextField *smsCodeTextField;
@property (strong, nonatomic) UIButton *sendSmsCodeButton;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *closeButton;

@end
