//
//  ViewController.m
//  MGJailbreakKit
//
//  Created by Mingle on 2020/3/7.
//  Copyright © 2020 Mingle. All rights reserved.
//

#import "ViewController.h"
#import "Checker.h"
#import "MGControlCenterHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MGControlCenterItem *item1 = [MGControlCenterItem new];
    item1.type = MGControlCenterItemInput;
    item1.title = @"+攻击力";
    item1.didMotifyBlock = ^(MGControlCenterItem * _Nonnull newItem) {
        NSLog(@"%@ = %@ enable: %@", newItem.title, newItem.value, @(newItem.enable));
    };
    
    MGControlCenterItem *item2 = [MGControlCenterItem new];
    item2.type = MGControlCenterItemSwitch;
    item2.title = @"无敌";
    item2.didMotifyBlock = ^(MGControlCenterItem * _Nonnull newItem) {
        NSLog(@"%@ = %@ enable: %@", newItem.title, newItem.value, @(newItem.enable));
    };
    
    [Checker startCheckWithAppKey:@"1" experienceMsg:@"您正在免费体验" buyMsg:@"一次购买，永久使用，仅需30元" completion:^(BOOL isVIP) {
        if (isVIP) {
            [MGControlCenterHUD show];
            [MGControlCenterHUD setControlCenterItems:@[item1, item2]];
            [MGControlCenterHUD setMessage:@"欢迎加入QQ交流群(******)"];
        }
    }];
}


@end
