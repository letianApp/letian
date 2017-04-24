//
// 
// 
//
//  Created by 恽雨晨 on 15/11/12.
//  Copyright © 2015年 恽雨晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YYExtension)
/**
 * 设置头像
 */
- (void)setHeader:(NSString *)url;

- (void)setHeaderImage:(UIImage *)image;

/**
 *  设置方形头像
 *
 *  @param url 头像的url
 */
- (void)setRectHeader:(NSString *)url;

/**
 *  设置圆形头像
 *
 *  @param url 头像的url
 */
- (void)setCircleHeader:(NSString *)url;
@end
