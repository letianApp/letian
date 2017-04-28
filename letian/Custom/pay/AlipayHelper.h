//
//  AlipayHelper.h
//
//  Created by yunyuchen on 15/11/21.
//  Copyright © 2015年 yunyuchen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AlipayResult)(NSDictionary *result);


//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface Product : NSObject{
    
@private
    NSString *_price;
    NSString *_subject;
    NSString *_orderNo;
}

@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *orderNo;

@end


@interface AlipayHelper : NSObject

+ (AlipayHelper *)shared;
- (void)alipay:(Product *)product block:(AlipayResult)block;

@end
