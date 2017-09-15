//
//  YYRequestManger.m
//  YYNetWroking
//
//  Created by yangyu on 2017/8/14.
//  Copyright © 2017年 yangyu. All rights reserved.
//

#import "YYRequestManger.h"
#import "YYBaseRequest.h"
@interface YYRequestManger()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManger;

@property (nonatomic, strong) NSMutableDictionary *requests;
@end


static NSString *YYUrlStringFromRequset(YYBaseRequest *request) {
    NSString *detaiUrl = request.url;
    if ([[detaiUrl lowercaseString] hasPrefix:@"http"]) {
        return detaiUrl;
    }
    
    NSString *baseUrl = request.baseUrl;
    if ([[baseUrl lowercaseString] hasPrefix:@"http"]) {
         return [NSString stringWithFormat:@"%@%@", baseUrl, detaiUrl.length==0?@"":detaiUrl];
    } else {
        return @"";
    }
}

@implementation YYRequestManger

+ (instancetype)sharedManger {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionManger = [AFHTTPSessionManager manager];
        self.requests = [NSMutableDictionary dictionary];
    }
    return self;
    
}

- (void)handleReponseResult:(NSURLSessionDataTask *)task response:(id)responseObject error:(NSError *)error {
    NSString *key = [self taskHashKey:task];
    YYBaseRequest *request = self.requests[key];
    request.responseObject = responseObject;
    request.error = error;
    
    //cookie
    if (request.useCookies) {
        [self saveCookies];
    }
    
    //网络请求结束
    [self requestDidFinsh:request];
    
}

- (NSString *)taskHashKey:(NSURLSessionDataTask *)task {
    return [NSString stringWithFormat:@"%lu", (unsigned long)[task hash]];
}

#pragma mark -public
- (void)addRequest:(YYBaseRequest *)request {
    
    //处理序列化
    YYRequestSerializerType requestSerializerType = request.requestSerializerType;
    switch (requestSerializerType) {
        case YYRequestSerializerTypeHTTP:{
            self.sessionManger.requestSerializer = [AFHTTPRequestSerializer serializer];
        }
            break;
            
        case YYRequestSerializerTypeJSON: {
            self.sessionManger.requestSerializer = [AFJSONRequestSerializer serializer];
        }
            break;
        default:
            break;
    }
    
    self.sessionManger.requestSerializer.timeoutInterval = request.requestTimeoutInterval;
    self.sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/xml", @"text/plain", @"text/json", @"text/javascript", @"image/png", @"image/jpeg", @"application/json", nil];
    
    NSString *url = YYUrlStringFromRequset(request);
    
    // 使用cookie
    if (request.useCookies) {
        [self loadCookies];
    }
    
    
    //处理URL
    
    YYRequestMethod  method = request.requestMethod;
    
    
    //处理参数
    id params = request.requestParameters;
    
    NSURLSessionDataTask *task = nil;
    switch (method) {
        case YYRequestMethodGET: {
            task = [self.sessionManger GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleReponseResult:task response:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleReponseResult:task response:nil error:error];
            }];
        }
            break;
            
        case YYRequestMethodPOST: {
            task = [self.sessionManger POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleReponseResult:task response:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleReponseResult:task response:nil error:error];
            }];
        }
            break;
            
        case YYRequestMethodPUT: {
            task = [self.sessionManger PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleReponseResult:task response:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleReponseResult:task response:nil error:error];
            }];
        }
            break;
            
        case YYRequestMethodDELETE: {
            task = [self.sessionManger DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleReponseResult:task response:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleReponseResult:task response:nil error:error];
            }];
        }
            break;
            
        case YYRequestMethodPATCH: {
            task = [self.sessionManger POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (int i = 0; i < request.image.count; i ++) {
                    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                    formatter.dateFormat=@"yyyyMMddHHmmss";
                    NSString *str=[formatter stringFromDate:[NSDate date]];
                    NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
                    UIImage *image = request.image[i];
                    NSData *imageData = UIImageJPEGRepresentation(image, request.imageSize);
                    [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
                }
                request.constructionBodyBlock(formData);
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                request.uploadProgress(uploadProgress);
                 NSLog(@"uploadProgress is %lld,总字节 is %lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //上传成功
                 [self handleReponseResult:task response:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //上传失败
                 [self handleReponseResult:task response:nil error:error];
            }];
        }
            break;
        default:
            break;
    }
    request.task = task;
    if (request.task) {
        NSString *key = [self taskHashKey:request.task];
        @synchronized(self) {
            [self.requests setValue:request forKey:key];
        }
    }
}

- (void)removeRequest:(YYBaseRequest *)request {
    [request.task cancel];
    NSString *key = [self taskHashKey:request.task];
    @synchronized(self) {
        [self.requests removeObjectForKey:key];
    }
}

#pragma mark - cookies
- (void)saveCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    if (cookies.count > 0) {
        NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        
        [[NSUserDefaults standardUserDefaults] setObject:cookieData forKey:COOKIE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)loadCookies {
    id cookieData = [[NSUserDefaults standardUserDefaults] objectForKey:COOKIE_KEY];
    if (!cookieData) {
        return;
    }
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookieData];
    if ([cookies isKindOfClass:[NSArray class]] && cookies.count > 0) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStorage setCookie:cookie];
        }
    }
}

#pragma mark - 网络请求结束
- (void)requestDidFinsh:(YYBaseRequest *)request {
    if (request.error) {
        if (request.failureCallBack) {
            request.failureCallBack(request);
        }
    } else {
        if (request.successCallBack) {
            request.successCallBack(request);
        }
    }
    
}
@end
