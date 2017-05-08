//
//  GQActionSheet.h
//  letian
//
//  Created by 郭茜 on 2017/3/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(int btnIndex);
typedef void(^CancelBlock)(void);

@interface GQActionSheet : UIWindow

- (instancetype)initWithTitles:(NSArray *)titles iconNames:(NSArray *)iconNames;

- (void)showActionSheetWithClickBlock:(ClickBlock)clickBlock cancelBlock:(CancelBlock)cancelBlock;

@end
