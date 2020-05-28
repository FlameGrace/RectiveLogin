//
//  TestVC.m
//  DemoProject
//
//  Created by Flame Grace on 2020/5/28.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "TestVC.h"
#import "Masonry.h"
#import "ReactiveObjC.h"

@interface TestVC ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"测试";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
        __weak typeof(self) weakSelf = self;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(64);
            make.width.equalTo(@(375));
            make.height.equalTo(@(667));
            make.centerX.equalTo(weakSelf.view);
        }];
        _tableView.backgroundColor = [UIColor whiteColor];

    }
    return _tableView;
}

@end
