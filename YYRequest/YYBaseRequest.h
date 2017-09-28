//
//  YYBaseRequest.h
//  YYNetWroking
//
//  Created by yangyu on 2017/8/14.
//  Copyright © 2017年 yangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class YYBaseRequest;

typedef NS_ENUM(NSInteger, YYRequestMethod){
    YYRequestMethodGET = 0,
    YYRequestMethodPOST,
    YYRequestMethodPUT,
    YYRequestMethodDELETE,
    YYRequestMethodPATCH,
    YYRequestDownTask,
};

typedef NS_ENUM(NSInteger, YYResponseSerializerType){
    YYResponseSerializerTypeHTTP = 0,
    YYResponseSerializerTypeJSON,
};


typedef NS_ENUM(NSInteger, YYRequestSerializerType){
    YYRequestSerializerTypeHTTP = 0,
    YYRequestSerializerTypeJSON,
};

typedef void(^YYRequestSuccessCallback)(__kindof YYBaseRequest *request);

typedef void(^YYRequestFailureCallback)(__kindof YYBaseRequest *request);


@interface YYBaseRequest : NSObject
@property (nonatomic, strong)NSURLSessionTask *task;
@property (nonatomic, copy) NSString *baseUrl;
/*! url*/
@property (nonatomic, copy) NSString *url;

/*! 网络请求方式*/
@property (nonatomic, assign) YYRequestMethod requestMethod;

/*! 请求超时*/
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

/*! paramenters参数*/
@property (nonatomic, strong) id requestParameters;

/*! 请求成功返回的responseObject*/
@property (nonatomic, strong) id responseObject;

/*! 上传图片  数组*/
@property (nonatomic, strong) NSArray <UIImage *>*image;
@property (nonatomic, assign) YYResponseSerializerType responseSerializerType;
@property (nonatomic, assign) YYRequestSerializerType requestSerializerType;

/*! 成功回调Block*/
@property (nonatomic, copy) YYRequestSuccessCallback successCallBack;

/*! 失败回调Blcok*/
@property (nonatomic, copy) YYRequestFailureCallback failureCallBack;

/*! 进度值*/
@property (nonatomic, copy) void (^uploadProgress)(NSProgress *progress);

/*! 下载路径*/
@property (nonatomic, copy) NSString *resumableDownloadPath;

/*! 下载路径Block*/
@property (nonatomic, strong) void (^uploadFilePath)(NSURL *filePath);
// POST upload request such as images, default nil
@property (nonatomic, copy) void (^constructionBodyBlock)(id<AFMultipartFormData>formData);

/*! 失败返回error*/
@property (nonatomic, strong) NSError *error;

// default is YES
@property (nonatomic, assign) BOOL useCookies;

// imageSize default is 0.28
@property (nonatomic, assign) float imageSize;
- (void)start;
- (void)startRequestSuccessCallBack:(YYRequestSuccessCallback)success failureCallBack:(YYRequestFailureCallback)failure;
- (void)stop;
@end
