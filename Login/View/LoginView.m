//
//  LoginView.m
//  DemoProject
//
//  Created by Flame Grace on 2020/5/27.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "LoginView.h"
#import "Masonry.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self phoneNumberTextField];
        [self smsCodeTextField];
        [self loginButton];
        [self sendSmsCodeButton];
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideKeyBoard];
}

- (void)hideKeyBoard{
    [self endEditing:YES];
}

- (UITextField *)phoneNumberTextField{
    if(!_phoneNumberTextField){
        _phoneNumberTextField = [[UITextField alloc]init];
        [self addSubview:_phoneNumberTextField];
        _phoneNumberTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
        __weak typeof(self) weakSelf = self;
        [_phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(100);
            make.width.equalTo(@(200));
            make.height.equalTo(@(40));
            make.centerX.equalTo(weakSelf);
        }];
        _phoneNumberTextField.placeholder = @"手机号";
        _phoneNumberTextField.layer.borderColor = [UIColor blueColor].CGColor;
        _phoneNumberTextField.layer.borderWidth = 1;
        _phoneNumberTextField.layer.cornerRadius = 5;
    }
    return _phoneNumberTextField;
}

- (UITextField *)smsCodeTextField{
    if(!_smsCodeTextField){
        _smsCodeTextField = [[UITextField alloc]init];
        [self addSubview:_smsCodeTextField];
        _smsCodeTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _smsCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        __weak typeof(self) weakSelf = self;
        [_smsCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(180);
            make.width.equalTo(@(200));
            make.height.equalTo(@(40));
            make.centerX.equalTo(weakSelf);
        }];
        _smsCodeTextField.placeholder = @"验证码";
        _smsCodeTextField.layer.borderColor = [UIColor blueColor].CGColor;
        _smsCodeTextField.layer.borderWidth = 1;
        _smsCodeTextField.layer.cornerRadius = 5;
    }
    return _smsCodeTextField;
}

- (UIButton *)sendSmsCodeButton{
    if(!_sendSmsCodeButton){
        _sendSmsCodeButton = [[UIButton alloc]init];
        [self addSubview:_sendSmsCodeButton];
        __weak typeof(self) weakSelf = self;
        [_sendSmsCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.smsCodeTextField).offset(-10);
            make.width.equalTo(@(80));
            make.height.equalTo(@(30));
            make.centerY.equalTo(weakSelf.smsCodeTextField);
        }];
        [_sendSmsCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendSmsCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendSmsCodeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_sendSmsCodeButton setTitleColor:[UIColor linkColor] forState:UIControlStateHighlighted];
        [_sendSmsCodeButton setTitleColor:[UIColor placeholderTextColor] forState:UIControlStateDisabled];
        [_sendSmsCodeButton setBackgroundColor:[UIColor whiteColor]];
        _sendSmsCodeButton.layer.borderColor = [UIColor blueColor].CGColor;
        _sendSmsCodeButton.layer.borderWidth = 1;
        _sendSmsCodeButton.layer.cornerRadius = 5;
        [_sendSmsCodeButton addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendSmsCodeButton;
}


- (UIButton *)loginButton{
    if(!_loginButton){
        _loginButton = [[UIButton alloc]init];
        [self addSubview:_loginButton];
        __weak typeof(self) weakSelf = self;
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(280);
            make.width.equalTo(@(200));
            make.height.equalTo(@(40));
            make.centerX.equalTo(weakSelf);
        }];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor linkColor] forState:UIControlStateHighlighted];
        [_loginButton setTitleColor:[UIColor placeholderTextColor] forState:UIControlStateDisabled];
        [_loginButton setBackgroundColor:[UIColor whiteColor]];
        _loginButton.layer.borderColor = [UIColor blueColor].CGColor;
        _loginButton.layer.borderWidth = 1;
        _loginButton.layer.cornerRadius = 5;
        [_loginButton addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)closeButton{
    if(!_closeButton){
        _closeButton = [[UIButton alloc]init];
        [self addSubview:_closeButton];
        __weak typeof(self) weakSelf = self;
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(30);
            make.top.equalTo(weakSelf).offset(30);
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
        }];
        [_closeButton setTitle:@"X" forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:25];
        [_closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor linkColor] forState:UIControlStateHighlighted];
        [_closeButton setBackgroundColor:[UIColor whiteColor]];
        _closeButton.layer.borderColor = [UIColor blueColor].CGColor;
        _closeButton.layer.borderWidth = 1;
        _closeButton.layer.cornerRadius = 15;
    }
    return _closeButton;
}

@end
