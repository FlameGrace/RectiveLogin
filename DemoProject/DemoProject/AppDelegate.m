//
//  AppDelegate.m
//  DemoProject
//
//  Created by Mac on 2019/12/20.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TestVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITabBarController *tab = [[UITabBarController alloc]init];
    NaviVC *navi1 = [[NaviVC alloc]initWithRootViewController:[[ViewController alloc]init]];
    [tab addChildViewController:navi1];
    
    NaviVC *navi2 = [[NaviVC alloc]initWithRootViewController:[[TestVC alloc]init]];
    [tab addChildViewController:navi2];
    
    self.rootNaviCon = [[NaviVC alloc]initWithRootViewController:tab];
    self.rootNaviCon.navigationBar.hidden = YES;
    self.rootNaviCon.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.rootNaviCon;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
