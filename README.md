# YYNetWorking

简单说明下YYRequest的使用吧 我看到很多AFN的封住基本都是一个类方法的套用，这样写的话的确很方便适用于简单的业务
我也参考了YTKNetWorking 但是YTK的封装比较重 我结合两点写了轻量级YYRequest也是为了减少C层代码 使用如下


# 使用方法

### 直接使用YYBaseRequest
YYBaseRequest *request = [YYBaseRequest new];

    request.requestMethod = YYRequestMethodGET; //默认GET
    
    request.url = @"v1/userInfo";
    
    request.requestParameters = @{};//字典参数
    
    [request startRequestSuccessCallBack:^(__kindof YYBaseRequest *request) {
        NSLog(@"%@",request.responseObject);
    } failureCallBack:^(__kindof YYBaseRequest 
    *request) {
        NSLog(@"%@",request.error);
	}];


### 继承YYBaseRequest  比如登录页面
loginRequest *logRequest = [[loginRequest alloc] initWithLoginRequest:@"" passWord:@""];

    [logRequest startRequestSuccessCallBack:^(__kindof YYBaseRequest *request) {
         NSLog(@"%@",request.responseObject);
    } failureCallBack:^(__kindof YYBaseRequest *request) {
        
    }];

### 上传图片 
UIImage *imag = [UIImage imageNamed:@""];

    YYBaseRequest *requstPath = [YYBaseRequest new];
    
    request.requestMethod = YYRequestMethodPATCH; //图片上传
    
    request.image = @[imag];
    
    request.imageSize = 0.8f;
    
    [requstPath startRequestSuccessCallBack:^(__kindof YYBaseRequest *request) {
        NSLog(@"%@",request.uploadProgress); //上传进度
    } failureCallBack:^(__kindof YYBaseRequest *request) {
        
    }];

####详细参考demo

# 安装
1. 下载YYRequest文件夹内的所有内容
2. 将YYRequest内的源文件添加(拖放)到你的工程。
3. 导入YYRequest
