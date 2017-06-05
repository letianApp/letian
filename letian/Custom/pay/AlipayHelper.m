//
//  AlipayHelper.m
//
//  Created by yunyuchen on 15/11/21.
//  Copyright © 2015年 yunyuchen. All rights reserved.
//

#import "AlipayHelper.h"
#import "Order.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation Product


@end

@implementation AlipayHelper

+ (AlipayHelper *)shared
{
    static AlipayHelper *_alipay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _alipay = [[AlipayHelper alloc]init];
    });
    return _alipay;
}


- (void)alipay:(Product *)product block:(AlipayResult)block
{
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *app_id = @"2017031406210593";
    NSString *seller_id = @"2088801357430645";
    NSString *rsa2PrivateKey = @"MIIEpAIBAAKCAQEA6klVgK2cZBxCNYTmhh+LpHu1/mIpLow+iwcXB264IX4RFFYJ+kasr4qgT3eAJ3qul1t6mEN1Y9qHm923KCCb1b1odxXpFoLn9aIhrvc8kQiausxWobGaqlqkgbT9GqBht85+gH97q/nAXsmYc24Lx7VqoGiQ71cXz3BFaTmjbvYHFIMZQ6E2g5CKs+CODYqmIa6eCISn8AJA3zcXKRmWRlr5+dAU86f7wcrv6fd8+VmgwIfgN8xmsq3jLbKJZEix45DDmJQRjX1w4GoV964gBGozCuZYNwWc1PbdNktgilL5/Ak2mMXOiLK607HtG9+yc3nuIMgLrR5dmCMasGuNQQIDAQABAoIBADtPi1zDFrdlTAGefnlv3Psr8lvO39wP1vl9NwBDsEuSTaKXUXlRkP/zmTfk6cWU0kQw/W00jrBTr0bvLyHyd2D5zUtweYygYTaW7+4KWwPgaMNnXXsbqir8PW80sWqfNX3Bwdan71gPJvsYEAcQ0dyh+bdYIXDl3HpAUuIbnFtHY1ytbS1Hrj35bzb6ilTgSVmsRi8R4XaebHXIGpDOV+AcnVHYmsS3vvJT1OZ8yU/XQQX0Abvu8DBhZ4yyVWzqRrF68WwhcHSLVu9SHhAeKEM2XOFTLGzdKmAf1yZCQbCmgbsKV2mbOHgbYJSlPcD0D37JtBX3Fi2qxYInC+WcylECgYEA/Rh3lKynOcgXZ2qxGli4oj4L/nqpAAuv1N8lEk+XYYBDrWSEcitBVA7Oz9koSEl5NVrzhFS0zwTxyT34xUMuljP5CR+hbCmZBPxIVy93VdbjFGLRqbWrD2S5eHcWngDjg/YFtM5s89acF39hVdtLmhunZHlXJEvazXEnlrH6n3UCgYEA7PmcPRdnLXsuYFYSv06iDhrB1yiiybEA236iaHO3zLTdDznniBlqkGYN1d9/8dmLYvgCoH1xq9c/dVuhOv+jiMPD79/uHbLV6OkhXnbNOhYYaF7pIGDlLCHONz39EtoJ+MD+dFIfLPK+ItPY0QzcHZtnKXPq3FnrhDncPPWO6R0CgYEAyqHqK3hHsnVGd5/uBz/9Irg2dhnScJzqu62kSpK6im9cv9f4SkfjV987KSGdpLJefp9A1DPVRuGYixw4rgZpqAwYWHugi66KOnmZmWQBURJoYAv1/L/cIsjrzUzbKMlhXmd8jhOvG1I5Sn7LeSfH0axOSpzzbbXlihIMNhRsqXkCgYEAhW01jyAyM+V7gzpza8u2awKdyatTnQRQW0W949njzxq2rPAJcRP+cDdF6vngbCf011CVChAXhI25aTaiXTm6tjKji9gllgsvbeh1pV52xxHRxFJMKLLl1idimLAKYibqHmlr28qxSvmSHMHy/iGjffgV6b0eq9rlRJnfa2NHh/ECgYBMWwYgpHCi21p1lE45T8WK7toAIbGTudeBGdBaBwizEUANMjqoCNjcCVLwbFcuvFwob6Jyix0L8cD1Bh/Wi7EMxXq49nC15p3JC+lyluJxY6lN86/V5uvq6pCK7ySJOxVTP2+jQ5YmEr+2Sv9Do2z2OGwNVpCo5UjD/4LUjZFemA==";
    
    NSString *rsaPrivateKey=@"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    if ([app_id length] == 0 ||
        [seller_id length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0)){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    Order *order = [[Order alloc] init];
    order.app_id = app_id;
    
    order.method = @"alipay.trade.app.pay";
    
    order.charset = @"utf-8";
    
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    order.version = @"1.0";
    
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    order.notify_url=@"http://webapi.rightpsy.com/PayCallBack/AliPayNoticefy";
    
    //  商品数据
    order.biz_content = [BizContent new];
    order.biz_content.subject =product.subject;
    order.biz_content.out_trade_no = product.orderNo;
    order.biz_content.timeout_express = @"60m";
    order.biz_content.total_amount = product.price;
    order.biz_content.product_code=@"QUICK_MSECURITY_PAY";

    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
//    NSLog(@"orderSpec = %@",orderInfo);
    
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
//    NSLog(@"ssssssssss%@",signedString);
    if (signedString != nil) {
        NSString *appScheme = @"rightpsy";
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
//        NSLog(@"厉害了%@",orderString);

        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
            block(resultDic);
        }];

        
    }

}

#pragma mark - 产生随机订单号


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
