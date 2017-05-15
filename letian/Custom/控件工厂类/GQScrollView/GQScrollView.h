//
//  GQScrollView.h
//  letian
//
//  Created by 郭茜 on 2017/3/6.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ImageViewClick)(NSInteger index);
@interface GQScrollView : UIView
@property (nonatomic,assign)BOOL isRunloop;//是否开启定时器 default NO
@property (nonatomic,assign)NSTimeInterval dur; //切换时间，默认是3秒
@property (nonatomic,strong)UIColor *color_pageControl;//
@property (nonatomic,strong)UIColor *color_currentPageControl;
@property (nonatomic,strong)ImageViewClick click;

/**轮播图

 @param frame frame
 @param images 图片数组
 @param isRunloop 是否需要轮播
 @param block 点击图片的block
 @return return value description
 */
-(instancetype)initWithFrame:(CGRect)frame
                   withImages:(NSArray *)images
                withIsRunloop:(BOOL)isRunloop
                    withBlock:(ImageViewClick)block;

@end
