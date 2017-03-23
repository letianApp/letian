//
//  YYCNetWorkTool.m
//  XCar
//
//  Created by 郭茜 on 15/10/19.
//  Copyright © 2015年 郭茜. All rights reserved.
//

#import "GQNetworkManager.h"

@implementation GQNetworkManager

+(instancetype)sharedNetworkManager
{
    static GQNetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@""];
        instance = [[self alloc] initWithBaseURL:url sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return instance;
}

+(instancetype) sharedNetworkToolWithoutBaseUrl
{
    static GQNetworkManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        NSURL *url = [NSURL URLWithString:@""];
        instance = [[self alloc] initWithBaseURL:url sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return instance;
}

@end
