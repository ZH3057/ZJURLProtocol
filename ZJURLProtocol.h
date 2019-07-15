//
//  ZJURLProtocol.h
//  ZJRequestInterceptor
//
//  Created by Jun Zhou on 2019/7/15.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJURLProtocol : NSURLProtocol


/**
 NSURLProtocol 基于 AF3.x(NSURLSession)拦截
 
 使用说明: 在APPDelegate方法 `- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions`中调用
 确保要mock的url的请求在`start`之后
 
 注意: AFHTTPSessionManager的方法`- (instancetype)initWithBaseURL:(nullable NSURL *)url
 sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration`在调用时传入的configuration是有值的
 
 json文件即为mock数据 格式填写 "urlPath" : "data" DEBUG模式下 不需要进行mock 删除json内容即可
 
     {
         "/mvp/course/app-preload" : {
                "code": 99999,
                "data": {
                        "isNeedPreload": 0,
                        "resourceId": 5,
                        "preloadZip": "https://appd.knowbox.cn/english/lisk5.zip",
                        "preloadSize": 23
                        },
                "msg": "成功测试数据"
            }
     }
 
 
 */
+ (void)start;

@end

NS_ASSUME_NONNULL_END
