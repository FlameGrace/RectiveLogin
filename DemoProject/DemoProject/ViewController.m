//
//  ViewController.m
//  DemoProject
//
//  Created by Mac on 2019/12/20.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "ViewController.h"
#import "LoginVC.h"
#import "Masonry.h"
#import "ReactiveObjC.h"
#import "LoginService.h"

@interface ViewController ()

@property (strong, nonatomic) UIButton *nickNameButton;
@property (strong, nonatomic) UIButton *exitButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人中心";
    [self nickNameButton];
    
    @weakify(self);
    [[self.exitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if([LoginService shareService].user){
            [[LoginService shareService] exitLoginCompleteBlock:^(id info, NSError *error) {
                NSLog(@"退出登录成功");
            }];
        }
    }];
    
    [[self.nickNameButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if(![LoginService shareService].user){
            LoginVC *vc = [[LoginVC alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    
    [RACObserve([LoginService shareService], user) subscribeNext:^(UserModel *user) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!user){
                self.exitButton.hidden = YES;
                [self.nickNameButton setTitle:@"点击登录" forState:UIControlStateNormal];
            }else{
                [self.nickNameButton setTitle:user.nickName forState:UIControlStateNormal];
                self.exitButton.hidden = NO;
            }
        });
    }];
    
}


- (UIButton *)nickNameButton{
    if(!_nickNameButton){
        _nickNameButton = [[UIButton alloc]init];
        [self.view addSubview:_nickNameButton];
        __weak typeof(self) weakSelf = self;
        [_nickNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(200);
            make.width.equalTo(@(200));
            make.height.equalTo(@(40));
            make.centerX.equalTo(weakSelf.view);
        }];
        [_nickNameButton setTitle:@"点击登录" forState:UIControlStateNormal];
        [_nickNameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_nickNameButton setTitleColor:[UIColor linkColor] forState:UIControlStateHighlighted];
        [_nickNameButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _nickNameButton;
}


- (UIButton *)exitButton{
    if(!_exitButton){
        _exitButton = [[UIButton alloc]init];
        [self.view addSubview:_exitButton];
        __weak typeof(self) weakSelf = self;
        [_exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(280);
            make.width.equalTo(@(200));
            make.height.equalTo(@(40));
            make.centerX.equalTo(weakSelf.view);
        }];
        [_exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor linkColor] forState:UIControlStateHighlighted];
        [_exitButton setTitleColor:[UIColor placeholderTextColor] forState:UIControlStateDisabled];
        [_exitButton setBackgroundColor:[UIColor whiteColor]];
        _exitButton.layer.borderColor = [UIColor blueColor].CGColor;
        _exitButton.layer.borderWidth = 1;
        _exitButton.layer.cornerRadius = 5;
    }
    return _exitButton;
}

@end
