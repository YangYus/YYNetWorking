//
//  LoginDataViewModel.h
//  YYNetWroking
//
//  Created by yangyu on 2017/9/13.
//  Copyright © 2017年 yangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYBaseRequest;

typedef void(^CallBack)(YYBaseRequest *request);

@interface LoginDataViewModel : NSObject
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, assign) CallBack callBacks;
- (instancetype)initWithLogin:(NSString *)userName passWord:(NSString *)pwd;
- (void)loginDataCallBack:(CallBack)callBack;

@end
