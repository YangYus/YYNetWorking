//
//  YYBaseRequest.m
//  YYNetWroking
//
//  Created by yangyu on 2017/8/14.
//  Copyright © 2017年 yangyu. All rights reserved.
//

#import "YYBaseRequest.h"
#import "YYRequestManger.h"
#import "YYRequestConfig.h"
@implementation YYBaseRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        self.baseUrl = DEBUGDOMAIN_API;
        self.url = @"";
        self.imageSize = 0.28f;
        self.requestMethod = YYRequestMethodGET;
        self.requestTimeoutInterval = 10;
        self.requestParameters = nil;
        self.responseSerializerType = YYResponseSerializerTypeJSON;
        self.requestSerializerType = YYRequestSerializerTypeJSON;
        self.useCookies = YES;
    }
    return self;
}

- (void)startRequestSuccessCallBack:(YYRequestSuccessCallback)success failureCallBack:(YYRequestFailureCallback)failure {
    self.successCallBack = success;
    self.failureCallBack = failure;
    [self start];
}



- (void)start {
    [[YYRequestManger sharedManger]addRequest:self];
}

- (void)stop {
    [[YYRequestManger sharedManger] removeRequest:self];
}


@end
