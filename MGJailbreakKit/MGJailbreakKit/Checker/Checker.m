//
//  Checker.m
//  Lost_Crack
//
//  Created by Mingle on 2020/2/13.
//

#import "Checker.h"
#import <UIKit/UIKit.h>
#import "AESCrypt.h"

BOOL enable = false;
NSString *APPKey = nil;

@interface Checker()

@property (copy, nonatomic) void (^checkCompletion)(BOOL);
@property (copy, nonatomic) NSString *buyMsg;

@end

@implementation Checker

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static Checker* obj;
    dispatch_once(&onceToken, ^{
        obj = [[Checker alloc] init];
    });
    return obj;
}

+ (void)startCheckWithAppKey:(NSString *)appKey experienceMsg:(nonnull NSString *)experienceMsg buyMsg:(nonnull NSString *)buyMsg completion:(nonnull void (^)(BOOL))block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        APPKey = appKey;
        NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:@"crackname"];
        NSString *pwd = [[NSUserDefaults standardUserDefaults] stringForKey:@"crackpwd"];
        if (name == nil && pwd == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"crackname"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"crackpwd"];
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:experienceMsg preferredStyle:UIAlertControllerStyleAlert];
            [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:alertCon animated:YES completion:nil];
            if (block) {
                block(YES);
            }
        } else {
            enable = [[AESCrypt encrypt:name password:APPKey] isEqualToString:pwd];
            [[self shareInstance] setCheckCompletion:block];
            [[self shareInstance] setBuyMsg:buyMsg];
            if (![[self shareInstance] isEnable]) {
                [[self shareInstance] showAlert];
            } else {
                block(YES);
            }
        }
    });
}

- (BOOL)isEnable {
    
    return enable;
}

- (void)showAlert {
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:_buyMsg preferredStyle:UIAlertControllerStyleAlert];
    [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"用户名";
    }];
    [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"密码";
    }];
    [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *name = [alertCon textFields][0].text;
        NSString *pwd = [alertCon textFields][1].text;
        if (name.length > 0 && pwd.length > 0) {
            NSLog(@"Checker:\n\tname:%@\n\tpwd:%@", name, [AESCrypt encrypt:name password:APPKey]);
            enable = [[AESCrypt encrypt:name password:APPKey] isEqualToString:pwd];
        }
        if (!enable && [[NSUserDefaults standardUserDefaults] stringForKey:@"crackname"] != nil) {
            [self showAlert];
        }
        [[NSUserDefaults standardUserDefaults] setObject:(name ?: @"") forKey:@"crackname"];
        [[NSUserDefaults standardUserDefaults] setObject:(pwd ?: @"") forKey:@"crackpwd"];
        
        if (enable) {
            self.checkCompletion(YES);
        }
    }]];
    [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:alertCon animated:YES completion:nil];
    
}

@end
