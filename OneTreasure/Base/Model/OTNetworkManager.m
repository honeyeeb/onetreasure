//
//  OTNetworkManager.m
//  OneTreasure
//
//  Created by Frederic on 2016/11/26.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTNetworkManager.h"

#import <AFNetworking/AFNetworking.h>
#import "OTStatistics.h"
#import <Reachability/Reachability.h>



@interface OTNetworkManager ()<NSURLSessionDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation OTNetworkManager

+ (instancetype)sharedManager {
    static OTNetworkManager *onceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onceManager = [[OTNetworkManager alloc] init];
    });
    return onceManager;
}

- (AFHTTPSessionManager *)httpSessionManager {
    if (!_httpSessionManager) {
        _httpSessionManager = [[AFHTTPSessionManager alloc] init];
        _httpSessionManager.requestSerializer.timeoutInterval = 10.0;
        
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"qyweb.josmob.com" ofType:@"cer"];
        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        // 是否允许,NO-- 不允许无效的证书
        [securityPolicy setAllowInvalidCertificates:YES];
        // 设置证书
        [securityPolicy setPinnedCertificates:certSet];
        
        _httpSessionManager.securityPolicy = securityPolicy;
        _httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    }
    return _httpSessionManager;
}


- (void)statisticsRequest:(NSString *)urlString params:(id)params success:(BOOL)success {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (urlString) {
        dic[@"url"] = urlString;
    }
    if (params) {
        dic[@"params"] = params;
    }
    NSString *key = success ? @"ot_http_request_success": @"ot_http_request_failed";
    [OTStatistics event:key attributes:dic];
}

- (NSURLSessionDataTask *)sendRequest:(NSString *)urlString method:(NSString *)method params:(id)params completion:(NetWorkHandler)handler {
    NSParameterAssert(urlString && method);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    request.timeoutInterval = 50.0;
    if (params) {
        NSData *httpBody;
        if ([params isKindOfClass:[NSString class]]) {
            httpBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        } else if ([params isKindOfClass:[NSDictionary class]]) {
            httpBody = [NSKeyedArchiver archivedDataWithRootObject:params];
        }
        request.HTTPBody = httpBody;
    }
    [request setValue:@"$Version=1" forHTTPHeaderField:@"Cookie2"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    NSString *userAgent = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f; BudnleID/%@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], app_version ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale], [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey]];
#endif
#pragma clang diagnostic pop
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, kCFStringTransformToLatin, false);
            userAgent = mutableUserAgent;
        }
        [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    OTLog(@"====%@?%@", url, params);
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSession *session = [NSURLSession sharedSession];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    WEAKSELF
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
            if (data) {
                NSError *jsonErr;
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonErr];
                NSInteger success = [result[@"success"] integerValue];
                // 账户系统用code
                NSString *codeString = [NSString stringWithFormat:@"%@", result[@"code"]];
                NSInteger code = -1;
                if (codeString) {
                    code = [codeString integerValue];
                }
                if (1 == success || code == 0) {
                    // 成功
                    if (handler) {
                        handler(result, nil);
                    }
                    [weakSelf statisticsRequest:urlString params:params success:YES];
                    
                } else {
                    if (handler) {
                        NSString *errMsg;
                        if (codeString) {
                            // 账户系统用
                            errMsg = result[@"msg"];
                        } else {
                            errMsg = result[@"message"];
                        }
                        handler(result, errMsg);
                    }
                    [weakSelf statisticsRequest:urlString params:params success:NO];
                }
                
            } else {
                if (handler) {
                    handler(nil, kErrorMessage);
                }
                [weakSelf statisticsRequest:urlString params:params success:NO];
            }
        }];
        return task;
    } else {
        if (handler) {
            handler(nil, kErrorMessage);
        }
        return nil;
    }
    
}

- (NSURLSessionDataTask *)GET:(NSString *)urlString params:(id)params completion:(NetWorkHandler)handler {
    return [self sendRequest:urlString method:@"GET" params:params completion:handler];
}

- (NSURLSessionDataTask *)POST:(NSString *)urlString params:(id)params completion:(NetWorkHandler)handler {
    return [self sendRequest:urlString method:@"POST" params:params completion:handler];
}

#pragma mark - AFN
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                   completion:(NetWorkHandler)handler{
    return [self.httpSessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSError *jsonErr;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&jsonErr];
            NSInteger success = [result[@"success"] integerValue];
            // 账户系统用code
            NSString *codeString = [NSString stringWithFormat:@"%@", result[@"code"]];
            NSInteger code = -1;
            if (codeString) {
                code = [codeString integerValue];
            }
            if (1 == success || code == 0) {
                // 成功
                if (handler) {
                    handler(result, nil);
                }
            } else {
                if (handler) {
                    NSString *errMsg;
                    if (codeString) {
                        // 账户系统用
                        errMsg = result[@"msg"];
                    } else {
                        errMsg = result[@"message"];
                    }
                    handler(nil, errMsg);
                }
            }
            
        } else {
            if (handler) {
                handler(nil, kErrorMessage);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (handler) {
            handler(nil, kErrorMessage);
        }
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                    completion:(NetWorkHandler)handler {
    return [self.httpSessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSError *jsonErr;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&jsonErr];
            NSInteger success = [result[@"success"] integerValue];
            if (1 == success) {
                // 成功
                if (handler) {
                    handler(result, nil);
                }
            } else {
                if (handler) {
                    handler(nil, result[@"message"]);
                }
            }
            
        } else {
            if (handler) {
                handler(nil, kErrorMessage);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (handler) {
            handler(nil, kErrorMessage);
        }
    }];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
}

// 如果发送的请求是https的,那么才会调用该方法
// challenge 质询,挑战 质询里有受保护空间，服务器信任等等东西，代理方法做的是安装这个证书
// NSURLAuthenticationMethodServerTrust
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    OTLog(@"%@",challenge.protectionSpace);//443端口，http是80端口
    //serverTrust服务信任重新传回去
    NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
    
    //NSURLCredential 授权信息
    
    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString: NSURLAuthenticationMethodServerTrust]) {
        do
        {
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            NSCAssert(serverTrust != nil, @"serverTrust is nil");
            if(nil == serverTrust)
                break; /* failed */
            /**
             *  导入多张CA证书（Certification Authority，支持SSL证书以及自签名的CA），请替换掉你的证书名称
             */
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"qyweb.josmob.com" ofType:@"cer"];//自签名证书
            NSData* caCert = [NSData dataWithContentsOfFile:cerPath];
            NSCAssert(caCert != nil, @"caCert is nil");
            if(nil == caCert)
                break; /* failed */
            SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCert);
            NSCAssert(caRef != nil, @"caRef is nil");
            if(nil == caRef)
                break; /* failed */
            //可以添加多张证书
            NSArray *caArray = @[(__bridge id)(caRef)];
            NSCAssert(caArray != nil, @"caArray is nil");
            if(nil == caArray)
                break; /* failed */
            //将读取的证书设置为服务端帧数的根证书
            OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
            NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
            if(!(errSecSuccess == status))
                break; /* failed */
            SecTrustResultType result = -1;
            //通过本地导入的证书来验证服务器的证书是否可信
            status = SecTrustEvaluate(serverTrust, &result);
            if(!(errSecSuccess == status))
                break; /* failed */
            OTLog(@"stutas:%d",(int)status);
            OTLog(@"Result: %d", result);
            BOOL allowConnect = (result == kSecTrustResultUnspecified) || (result == kSecTrustResultProceed);
            if (allowConnect) {
                OTLog(@"success");
            } else {
                OTLog(@"error");
            }
            /* kSecTrustResultUnspecified and kSecTrustResultProceed are success */
            if(!allowConnect)
            {
                break; /* failed */
            }
#if 0
            /* Treat kSecTrustResultConfirm and kSecTrustResultRecoverableTrustFailure as success */
            /*   since the user will likely tap-through to see the dancing bunnies */
            if(result == kSecTrustResultDeny || result == kSecTrustResultFatalTrustFailure || result == kSecTrustResultOtherError)
                break; /* failed to trust cert (good in this case) */
#endif
            // The only good exit point
            OTLog(@"信任该证书");
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
            return [[challenge sender] useCredential: credential
                          forAuthenticationChallenge: challenge];
        }
        while(0);
    }
    // Bad dog
    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,credential);
    return [[challenge sender] cancelAuthenticationChallenge: challenge];
    
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
}

@end
