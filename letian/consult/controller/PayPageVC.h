//
//  PayPageVC.h
//  letian
//
//  Created by J on 2017/3/30.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PayPageVC : UIViewController

/**
 *  定义了一个pushToOrderVc的Block
 */
typedef void(^pushToOrderVc)();
/**
 *  用上面定义的pushToOrderVc声明一个Block,声明的这个Block必须遵守声明的要求。
 */
@property (nonatomic, copy) pushToOrderVc push;

@property (nonatomic) NSInteger orderID;

@property(nonatomic,copy)NSString *orderNo;

@property(nonatomic,copy)NSString *orderTypeString;

@property(nonatomic,copy)NSString *consultorName;

@end
