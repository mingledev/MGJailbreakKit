//
//  Checker.h
//  Lost_Crack
//
//  Created by Mingle on 2020/2/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Checker : NSObject

+ (void)startCheckWithAppKey:(NSString *)appKey experienceMsg:(NSString *)experienceMsg buyMsg:(NSString *)buyMsg completion:(void (^)(BOOL isVIP))block;

@end

NS_ASSUME_NONNULL_END
