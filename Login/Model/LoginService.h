//
//  LoginService.h
//  DemoProject
//
//  Created by Flame Grace on 2020/5/27.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "SmsCode.h"

#define Noti_LoginSuccess (@"Noti_LoginSuccess")
#define Noti_LogoutSuccess (@"Noti_LogoutSuccess")

typedef void(^CompleteBlock)(id info, NSError *error);
typedef void(^CountDownBlock)(NSInteger countDown);

@interface LoginService : NSObject

@property (strong, readonly, nonatomic) UserModel *user;
@property (strong, readonly, nonatomic) SmsCode *hadSmsCode;

+ (instancetype)shareService;

- (void)loginWithPhoneNumber:(NSString *)phoneNumber smsCode:(NSString *)smsCode completeBlock:(CompleteBlock)completeBlock;

- (void)exitLoginCompleteBlock:(CompleteBlock)completeBlock;

- (void)senSmsCodeToPhoneNumber:(NSString *)phoneNumber completeBlock:(CompleteBlock)completeBlock countDownDuration:(NSInteger)countDownDuration countDownHandler:(CountDownBlock)countDownHandler;

- (BOOL)canSenSmsCodeToPhoneNumber:(NSString *)phoneNumber;

@end
