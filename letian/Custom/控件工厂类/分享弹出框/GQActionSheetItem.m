//
//  GQActionSheetItem.m
//  PracticeDemo
//
//  Created by guoqian on 15/11/11.
//  Copyright © 2015年 guoqian. All rights reserved.
//

#import "GQActionSheetItem.h"

@implementation GQActionSheetItem

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect titleRect = CGRectMake(5, CGRectGetHeight(self.bounds) - 50, CGRectGetWidth(self.bounds)-10, 40);
    return titleRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect imageRect = self.bounds;
    imageRect.size.height = CGRectGetWidth(self.bounds);
    
    return imageRect;
}

- (void)setTitle:(NSString *)title image:(UIImage *)image
{
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
}

@end
