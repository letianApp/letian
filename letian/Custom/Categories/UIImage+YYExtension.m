//
//  UIImage+YYCExtension.m
//  bsbdj
//
//  Created by 恽雨晨 on 15/11/12.
//  Copyright © 2015年 恽雨晨. All rights reserved.
//

#import "UIImage+YYExtension.h"

@implementation UIImage (YYExtension)

+(instancetype)circleImage:(UIImage *)image
{

    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextAddEllipseInRect(ctx, rect);
    
    CGContextClip(ctx);
    
    [image drawInRect:rect];
    
    UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmpImage;


}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}

+(UIImage *) circleImageWithImageName:(NSString *) name borderWidth:(CGFloat) width color:(UIColor*)bordercolor
{
    UIImage *image = [UIImage imageNamed:name];
    
    //CGFloat borderWidth = 5;
    
    CGSize size = CGSizeMake(image.size.width + 2 * width, image.size.height + 2 * width);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    UIBezierPath *bigCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    
    [bordercolor set];
    
    [bigCircle fill];
    
    UIBezierPath *imgCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width, width, image.size.width, image.size.height)];
    
    [imgCircle addClip];
    
    [image drawAtPoint:CGPointMake(width, width)];
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImg;
    
}

+(UIImage *) circleImageWithNetImageName:(UIImage *) image borderWidth:(CGFloat) width color:(UIColor*)bordercolor
{
    
    CGSize size = CGSizeMake(image.size.width + 2 * width, image.size.height + 2 * width);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    UIBezierPath *bigCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    
    [bordercolor set];
    
    [bigCircle fill];
    
    UIBezierPath *imgCircle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width, width, image.size.width, image.size.height)];
    
    [imgCircle addClip];
    
    [image drawAtPoint:CGPointMake(width, width)];
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    return newImg;
    
}



@end
