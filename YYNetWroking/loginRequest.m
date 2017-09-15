//
//  loginRequest.m
//  YYNetWroking
//
//  Created by yangyu on 2017/8/14.
//  Copyright © 2017年 yangyu. All rights reserved.
//

#import "loginRequest.h"

@implementation loginRequest

- (instancetype)initWithLoginRequest:(NSString *)userName passWord:(NSString *)pwd {
    if (self = [super init]) {
        self.userName = userName;
        self.passWord = pwd;
    }
    return self;
}

- (NSString *)url {
    return @"user/login";
}

- (YYRequestMethod)requestMethod {
    return YYRequestMethodPOST;
}

- (id)requestParameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.userName forKey:@"username"];
    [params setValue:self.passWord forKey:@"password"];
    return params;
}
@end
