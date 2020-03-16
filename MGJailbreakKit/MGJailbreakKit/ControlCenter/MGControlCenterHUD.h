//
//  MGControlCenterHUD.h
//  MGJailbreakKit
//
//  Created by Mingle on 2020/3/7.
//  Copyright © 2020 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGControlCenterItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGControlCenterHUD : UIButton

+ (void)show;

+ (void)hide;

/// 设置功能
/// @param items 功能列表
+ (void)setControlCenterItems:(NSArray<MGControlCenterItem *> *)items;

/// 设置提示消息
+ (void)setMessage:(NSString *)msg;

/// 设置启动插件的回调
+ (void)setDidLanchCallback:(void (^)(void))block;

+ (void)setCloseCallback:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
