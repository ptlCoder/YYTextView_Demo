//
//  WBFeedHelper.h
//  YYKitExample
//
//  Created by ibireme on 15/9/5.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYKit.h"
/**
 很多都写死单例了，毕竟只是 Demo。。
 */
@interface WBStatusHelper : NSObject
/// At正则 例如 @王思聪
+ (NSRegularExpression *)regexAt;


@end
