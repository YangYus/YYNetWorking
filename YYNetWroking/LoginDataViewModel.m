//
//  LoginDataViewModel.m
//  YYNetWroking
//
//  Created by yangyu on 2017/9/13.
//  Copyright © 2017年 yangyu. All rights reserved.
//

#import "LoginDataViewModel.h"
#import "loginRequest.h"
@implementation LoginDataViewModel

- (instancetype)initWithLogin:(NSString *)userName passWord:(NSString *)pwd {
    if (self = [super init]) {
        _userName = userName;
        _passWord = pwd;
    }
    return self;
}

- (void)loginDataCallBack:(CallBack)callBack {
    loginRequest *logRequest = [[loginRequest alloc] initWithLoginRequest:_userName passWord:_passWord];
    [logRequest startRequestSuccessCallBack:^(__kindof YYBaseRequest *request) {
        if (!request.error) {
            callBack(request);
        }
    } failureCallBack:^(__kindof YYBaseRequest *request) {
        
    }];
}

@end
