//
//  MGControlCenterView.h
//  MGJailbreakKit
//
//  Created by Mingle on 2020/3/7.
//  Copyright © 2020 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGControlCenterItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGControlCenterView : UIView

@property (strong, nonatomic) NSArray<MGControlCenterItem *> *controlItems;
@property (copy, nonatomic, nullable) NSString *msg;
@property (copy, nonatomic) void (^closeCallback)(void);
@property (copy, nonatomic) void (^launchCallback)(void);

@end

NS_ASSUME_NONNULL_END
