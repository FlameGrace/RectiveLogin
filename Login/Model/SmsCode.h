//
//  SmsCode.h
//  DemoProject
//
//  Created by Flame Grace on 2020/5/27.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmsCode : NSObject

@property (strong, nonatomic, readonly) NSString *phoneNumber;
@property (assign, nonatomic, readonly) NSTimeInterval sendTime;
@property (assign, nonatomic, readonly) NSInteger countDownDuration;

@end
