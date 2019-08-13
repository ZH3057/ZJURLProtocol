//
//  ZJURLProtocol.m
//  ZJRequestInterceptor
//
//  Created by Jun Zhou on 2019/7/15.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import "ZJURLProtocol.h"
#import <objc/runtime.h>
#import <AFNetworking/AFNetworking.h>

static NSString * const kHasStartLoading = @"kHasStartLoading";

@interface ZJURLProtocol ()

@property (nonatomic, strong) NSDictionary *mockDataDict;

@end


@implementation ZJURLProtocol

#if DEBUG

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self start];
    });
}

#endif

// MARK: - init

static ZJURLProtocol * _instance = nil;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZJURLProtocol alloc] init];
    });
    return _instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (NSDictionary *)mockDataDict {
    if (!_mockDataDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ZJMockData" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        _mockDataDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    return _mockDataDict;
}


+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([NSURLProtocol propertyForKey:kHasStartLoading inRequest:request]) {
        return NO;
    }
    
    NSString *path = request.URL.path;
    if (path && [ZJURLProtocol shareInstance].mockDataDict[path]) {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    
    [NSURLProtocol setProperty:@(YES) forKey:kHasStartLoading inRequest:self.request.mutableCopy];
    
    NSString *path = self.request.URL.path;
    NSDictionary *dataDict = [ZJURLProtocol shareInstance].mockDataDict[path];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    //data = [@"error data" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL
                                                        MIMEType:@"text/plain"
                                           expectedContentLength:data.length
                                                textEncodingName:nil];
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading {
    
}


+ (void)start {
    [NSURLProtocol registerClass:ZJURLProtocol.class];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.protocolClasses = @[ZJURLProtocol.class];
}



@end

#if DEBUG

@implementation AFHTTPSessionManager (ZJURLProtocol)

+ (void)load {
    Method org_load = class_getInstanceMethod(self, @selector(initWithBaseURL:sessionConfiguration:));
    Method rep_load = class_getInstanceMethod(self, @selector(zj_initWithBaseURL:sessionConfiguration:));
    method_exchangeImplementations(org_load, rep_load);
}

- (instancetype)zj_initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (!configuration) configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.protocolClasses = @[[NSClassFromString(@"ZJURLProtocol") class]];
    return [self zj_initWithBaseURL:url sessionConfiguration:configuration];
}

@end

#endif
