//
//  LoginService.m
//  DemoProject
//
//  Created by Flame Grace on 2020/5/27.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "LoginService.h"
#import "AFNetworking.h"
#import "ReactiveObjC.h"
#import "DispatchTimer.h"
#import "YYModel.h"

@interface UserModel(LoginService)

@property (strong, nonatomic, readwrite) NSString *phoneNumber;
@property (strong, nonatomic, readwrite) NSString *nickName;
@property (strong, nonatomic, readwrite) NSString *token;

@end

@interface SmsCode(LoginService)

@property (strong, nonatomic, readwrite) NSString *phoneNumber;
@property (assign, nonatomic, readwrite) NSTimeInterval sendTime;
@property (assign, nonatomic, readwrite) NSInteger countDownDuration;

@end

@interface LoginService()

@property (strong, readwrite, nonatomic) UserModel *user;
@property (strong, readwrite, nonatomic) SmsCode *hadSmsCode;
@property (strong, readwrite, nonatomic) DispatchTimer *smsCodeTimer;
@end

@implementation LoginService
static LoginService *loginService = nil;

+ (instancetype)shareService{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginService = [[LoginService alloc]init];
    });
    return loginService;
}

- (instancetype)init{
    if(self = [super init]){
        [self readLoginDataFromLocal];
    }
    return self;
}

- (NSString *)loginDataUserDefaultsKey{
    return [NSStringFromClass([self class]) stringByAppendingString:@"LoginData"];
}

- (void)saveLoginDataToLocal{
    if(!self.user){
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[self loginDataUserDefaultsKey]];
    }else{
        NSDictionary *dic = [self.user yy_modelToJSONObject];
        [[NSUserDefaults standardUserDefaults] setValue:dic forKey:[self loginDataUserDefaultsKey]];
    }
}

- (void)readLoginDataFromLocal{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey: [self loginDataUserDefaultsKey]];
    self.user = [UserModel yy_modelWithJSON:dic];
    if(self.user){
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_LoginSuccess object:nil];
    }
}

- (void)loginWithPhoneNumber:(NSString *)phoneNumber smsCode:(NSString *)smsCode completeBlock:(CompleteBlock)completeBlock{
    if(phoneNumber.length!=11||smsCode.length!=6){
        if(completeBlock){
            completeBlock(nil,[NSError errorWithDomain:@"参数错误" code:0 userInfo:nil]);
        }
        return;
    }
    __weak typeof(self) weakself = self;
    [NSThread detachNewThreadWithBlock:^{
        sleep(1);
        if(!weakself.hadSmsCode || ![weakself.hadSmsCode.phoneNumber isEqualToString:phoneNumber]){
            if(completeBlock){
                completeBlock(nil,[NSError errorWithDomain:@"未请求验证码" code:0 userInfo:nil]);
            }
            return;
        }
        if([smsCode isEqualToString:@"666666"]){
            weakself.user = [[UserModel alloc]init];
            weakself.user.phoneNumber = phoneNumber;
            weakself.user.nickName = @"哈哈";
            weakself.user.token = @"xxxxxxxxxxx";
            [weakself saveLoginDataToLocal];
            if(completeBlock){
                completeBlock(@{@"nickName":@"哈哈",@"token":@"xxxxxxxxxxx"},nil);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:Noti_LoginSuccess object:nil];
        }else{
            if(completeBlock){
                completeBlock(nil,[NSError errorWithDomain:@"验证码错误" code:0 userInfo:nil]);
            }
        }
    }];
}

- (void)exitLoginCompleteBlock:(CompleteBlock)completeBlock{
    self.user = nil;
    self.smsCodeTimer = nil;
    self.hadSmsCode = nil;
    [self saveLoginDataToLocal];
    if(completeBlock){
        completeBlock(nil,nil);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_LogoutSuccess object:nil];
    
}

- (BOOL)canSenSmsCodeToPhoneNumber:(NSString *)phoneNumber{
    if(phoneNumber.length!=11){
        return NO;
    }
    if(self.hadSmsCode && [self.hadSmsCode.phoneNumber isEqualToString:phoneNumber]){
        NSTimeInterval time = [[NSDate date]timeIntervalSince1970] - self.hadSmsCode.sendTime;
        if(time < self.hadSmsCode.countDownDuration){
            return NO;
        }
    }
    return YES;
}

- (void)senSmsCodeToPhoneNumber:(NSString *)phoneNumber completeBlock:(CompleteBlock)completeBlock countDownDuration:(NSInteger)countDownDuration countDownHandler:(CountDownBlock)countDownHandler{
    if(phoneNumber.length!=11){
        if(completeBlock){
            completeBlock(nil,[NSError errorWithDomain:@"参数错误" code:0 userInfo:nil]);
        }
        return;
    }
    __weak typeof(self) weakself = self;
    [NSThread detachNewThreadWithBlock:^{
        sleep(1);
        weakself.hadSmsCode = [[SmsCode alloc]init];
        weakself.hadSmsCode.phoneNumber = phoneNumber;
        NSTimeInterval sendTime = [[NSDate date] timeIntervalSince1970];
        weakself.hadSmsCode.sendTime = sendTime;
        weakself.hadSmsCode.countDownDuration = countDownDuration;
        
        weakself.smsCodeTimer = [[DispatchTimer alloc]initWithDuration:1 handleBlock:^{
            NSInteger time = countDownDuration - ([[NSDate date]timeIntervalSince1970] - sendTime);
            if(countDownHandler){
                countDownHandler(time);
            }
            if(time == 0){
                [weakself.smsCodeTimer endTimer];
            }
        }];
        [weakself.smsCodeTimer startTimer];
        if(completeBlock){
            completeBlock(@{@"smsCode":@"666666"},nil);
        }
    }];
}

@end
