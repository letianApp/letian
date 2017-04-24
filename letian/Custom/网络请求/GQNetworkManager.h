//
//  YYCNetWorkTool.h
//  XCar
//
//  Created by 郭茜 on 15/10/19.
//  Copyright © 2015年 郭茜. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//网络请求工具对象
@interface GQNetworkManager : AFHTTPSessionManager

/**
 *  单例对象有默认的请求URL
 */
+(instancetype) sharedNetworkManager;
/**
 *  单例对象无默认的请求URL
 */
+(instancetype) sharedNetworkToolWithoutBaseUrl;

@end
