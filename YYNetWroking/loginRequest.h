//
//  loginRequest.h
//  YYNetWroking
//
//  Created by yangyu on 2017/8/14.
//  Copyright © 2017年 yangyu. All rights reserved.
//

#import "YYBaseRequest.h"

@interface loginRequest : YYBaseRequest
- (instancetype)initWithLoginRequest:(NSString *)userName passWord:(NSString *)pwd;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *passWord;
@end
