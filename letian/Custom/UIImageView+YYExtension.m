//
//  UIImageView+XMGExtension.m
//  
//
//  Created by 恽雨晨 on 15/11/12.
//  Copyright © 2015年 恽雨晨. All rights reserved.
//

#import "UIImageView+YYExtension.h"
#import "UIImageView+WebCache.h"
#import "UIImage+YYExtension.h"

@implementation UIImageView (YYExtension)
- (void)setHeader:(NSString *)url
{
    [self setCircleHeader:url];
}

- (void)setHeaderImage:(UIImage *)image
{
    self.image = [UIImage circleImage:image];
}

- (void)setRectHeader:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ShopplaceholderImage"]];
}

- (void)setCircleHeader:(NSString *)url
{
    __weak typeof(self) weakSelf = self;
    UIImage *placeholder = [UIImage circleImage:[UIImage imageNamed:@"ShopplaceholderImage"] ];
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:
     ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       // 如果图片下载失败，就不做任何处理，按照默认的做法：会显示占位图片
       if (image == nil) return;
       
         weakSelf.image =[UIImage circleImageWithNetImageName:image borderWidth:5.0 color:[UIColor whiteColor]];
   }];
}
@end
