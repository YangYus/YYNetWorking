//
//  ViewController.m
//  YYNetWroking
//
//  Created by yangyu on 2017/8/14.
//  Copyright © 2017年 yangyu. All rights reserved.
//

#import "ViewController.h"
#import "YYBaseRequest.h"
#import "loginRequest.h"
#import "LoginDataViewModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //可以直接使用基类
    YYBaseRequest *request = [YYBaseRequest new];
    request.requestMethod = YYRequestMethodGET; //默认GET
    request.url = @"v1/userInfo";
    request.requestParameters = @{};//字典参数
    [request startRequestSuccessCallBack:^(__kindof YYBaseRequest *request) {
        NSLog(@"%@",request.responseObject);
    } failureCallBack:^(__kindof YYBaseRequest *request) {
        NSLog(@"%@",request.error);
    }];
    
    //可以对不同的业务创建相应的网络层
    loginRequest *logRequest = [[loginRequest alloc] initWithLoginRequest:@"" passWord:@""];
    [logRequest startRequestSuccessCallBack:^(__kindof YYBaseRequest *request) {
       
    } failureCallBack:^(__kindof YYBaseRequest *request) {
        
    }];
    
    
    UIImage *imag = [UIImage imageNamed:@""];
    YYBaseRequest *requstPath = [YYBaseRequest new];
    request.requestMethod = YYRequestMethodPATCH; //图片上传
    request.image = @[imag];
    request.imageSize = 0.8f;
    [requstPath startRequestSuccessCallBack:^(__kindof YYBaseRequest *request) {
        NSLog(@"%@",request.uploadProgress); //上传进度
       
    } failureCallBack:^(__kindof YYBaseRequest *request) {
        
    }];
    
    //这个参考思想 可以忽略
//    LoginDataViewModel *loginM = [[LoginDataViewModel alloc] initWithLogin:@"" passWord:@""];
//    [loginM loginDataCallBack:^(YYBaseRequest *request) {
//        NSLog(@"%@",request.responseObject);
//    }];
    
    YYBaseRequest *downRequst = [YYBaseRequest new];
    downRequst.requestMethod = YYRequestDownTask;
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    //设置下载路径
    downRequst.resumableDownloadPath = filePath;
    [downRequst startRequestSuccessCallBack:^(__kindof YYBaseRequest *request) {
        NSLog(@"返回的下载Url = %@",request.responseObject);
    } failureCallBack:^(__kindof YYBaseRequest *request) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
