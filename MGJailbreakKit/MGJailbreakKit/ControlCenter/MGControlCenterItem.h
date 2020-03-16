//
//  MGControlCenterItem.h
//  MGJailbreakKit
//
//  Created by Mingle on 2020/3/7.
//  Copyright © 2020 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MGControlCenterItemType) {
    MGControlCenterItemSwitch,
    MGControlCenterItemInput
};

NS_ASSUME_NONNULL_BEGIN

@interface MGControlCenterItem : NSObject

@property (assign, nonatomic) MGControlCenterItemType type;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic, nullable) NSString *value;
@property (assign, nonatomic) BOOL enable;
@property (copy, nonatomic) void (^didMotifyBlock)(MGControlCenterItem *newItem);

@end

NS_ASSUME_NONNULL_END
