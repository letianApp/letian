//
//  GQActionSheetItem.h
//  letian
//
//  Created by 郭茜 on 2017/3/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQActionSheetItem : UIButton

@property (nonatomic, assign) int     btnIndex;

- (void)setTitle:(NSString *)title image:(UIImage *)image;

@end
