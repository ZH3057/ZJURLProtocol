# ZJURLProtocol

基于`NSURLProtocol`, `AFNetworking3.x` 进行请求拦截 返回mock数据

 使用说明: 在APPDelegate方法 `- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions`中调用
 确保要mock的url的请求在`start`之后
 
```objc
 - (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#if DEBUG || TEST || CUSTOMDEBUG
    [ZJURLProtocol start];
#else
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#endif
    [self.window makeKeyAndVisible];
    
    return YES;
}
```

 
 注意: AFHTTPSessionManager的方法`- (instancetype)initWithBaseURL:(nullable NSURL *)url
 sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration`在调用时传入的configuration是有值的
 
 json文件即为mock数据 格式填写 "urlPath" : "data" DEBUG模式下 不需要进行mock 删除json内容, 或者修改path即可
 
 ```json
 
 {
    "/***/****/path" : {
        "code": 99999,
        "data": {
            ....
        },
        "msg": "成功测试数据"
    }
}
 
 ```
