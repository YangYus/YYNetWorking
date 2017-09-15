//
//  YYRequestManger.h
//  YYNetWroking
//
//  Created by yangyu on 2017/8/14.
//  Copyright © 2017年 yangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define COOKIE_KEY @"CookieKey"

@class YYBaseRequest;
@interface YYRequestManger : NSObject
+ (instancetype)sharedManger;

- (void)addRequest:(YYBaseRequest *)request;

- (void)removeRequest:(YYBaseRequest *)request;
@end
