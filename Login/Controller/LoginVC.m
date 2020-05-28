//
//  LoginVC.m
//  DemoProject
//
//  Created by Flame Grace on 2020/5/27.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "LoginVC.h"
#import "LoginView.h"
#import "LoginService.h"
#import "ReactiveObjC.h"

@interface LoginVC ()

@property (strong, nonatomic) LoginView *loginView;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, 365, 667)];
    [self.view addSubview:self.loginView];
    
    @weakify(self);
    //设置登录按钮信号
    [[RACSignal combineLatest:@[[self.loginView.phoneNumberTextField rac_textSignal], [self.loginView.smsCodeTextField rac_textSignal]]
                               reduce:^(NSString *phoneNumber, NSString *smsCode) {
        NSLog(@"phoneNumber:%@,smsCode:%@",phoneNumber,smsCode);
        @strongify(self)
        //手机号不能超过11
        if(phoneNumber.length >11){
            phoneNumber = [phoneNumber substringToIndex:11];
            self.loginView.phoneNumberTextField.text = phoneNumber;
        }
        //验证码不能超过6
        if(smsCode.length >6){
            smsCode = [smsCode substringToIndex:6];
            self.loginView.smsCodeTextField.text = smsCode;
        }
        return @(phoneNumber.length == 11 && smsCode.length == 6);
    }] subscribeNext:^(NSNumber *valid) {
        @strongify(self)
        //登录按钮是否可用
        self.loginView.loginButton.enabled = valid.boolValue;
    }];
    
    //发送验证码按钮是否可用
    //倒计时中，如果修改手机号，默认可以点击
    [[self.loginView.phoneNumberTextField rac_textSignal] subscribeNext:^(NSString *phoneNumber) {
        @strongify(self)
        BOOL valid = [[LoginService shareService] canSenSmsCodeToPhoneNumber:phoneNumber];
        self.loginView.sendSmsCodeButton.enabled = valid;
    }];
    
    //点击发送验证码按钮后发送验证码，发送成功后开始倒计时
    [[self.loginView.sendSmsCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        NSLog(@"开始发送验证码");
        [[LoginService shareService] senSmsCodeToPhoneNumber:self.loginView.phoneNumberTextField.text completeBlock:^(id info, NSError *error) {
            NSLog(@"发送验证码结果：%@，错误：%@",info,error);
            if(!error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loginView.sendSmsCodeButton.enabled = NO;
                });
            }
        } countDownDuration:15 countDownHandler:^(NSInteger countDown) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loginView.sendSmsCodeButton setTitleColor:[UIColor placeholderTextColor] forState:UIControlStateNormal];
                [self.loginView.sendSmsCodeButton setTitle:[NSString stringWithFormat:@"%@",@(countDown)] forState:UIControlStateNormal];
                if(countDown == 0){
                    [self.loginView.sendSmsCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                    [self.loginView.sendSmsCodeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    self.loginView.sendSmsCodeButton.enabled = YES;
                }
            });
        }];
    }];
    
    //点击登录按钮开始登录
    [[self.loginView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        NSLog(@"开始登录");
        [[LoginService shareService]loginWithPhoneNumber:self.loginView.phoneNumberTextField.text smsCode:self.loginView.smsCodeTextField.text completeBlock:^(id info, NSError *error) {
            NSLog(@"登录结果：%@，错误：%@",info,error);
            if(!error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }];
    }];
    
    //点击登录按钮开始登录
    [[self.loginView.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}




@end
