//
//  GQActionSheetItem.h
//  PracticeDemo
//
//  Created by guoqian on 15/11/11.
//  Copyright © 2015年 guoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQActionSheetItem : UIButton

@property (nonatomic, assign) int     btnIndex;

- (void)setTitle:(NSString *)title image:(UIImage *)image;

@end
