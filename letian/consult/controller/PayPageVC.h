//
//  PayPageVC.h
//  letian
//
//  Created by J on 2017/3/30.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PayPageVC : UIViewController

//typedef void(^pushToOrderVc)();


//@property (nonatomic, copy) pushToOrderVc push;

@property (nonatomic) NSInteger orderID;

@property(nonatomic,copy)NSString *orderNo;

@property (nonatomic) float totalFee;

@property(nonatomic,copy)NSString *orderTypeString;

@property(nonatomic,copy)NSString *consultorName;

@property(nonatomic,assign)CGFloat price;//应付款

@end
