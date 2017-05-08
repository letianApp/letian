//
//  TAdLaunchImageView.m
//  TYLaunchAnimationDemo
//
//  Created by tanyang on 15/12/8.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "TAdLaunchImageView.h"
#import "DrawCircleProgressButton.h"

@interface TAdLaunchImageView ()

@property (nonatomic, weak) UIImageView *adImageView;

@end

@implementation TAdLaunchImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addAdImageView];
        
        [self addSingleTapGesture];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        
        [self addAdImageView];
        
        [self addSingleTapGesture];
    }
    return self;
}

- (void)addAdImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    _adImageView = imageView;
}

- (void)addSingleTapGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture:)];
    [self addGestureRecognizer:singleTap];
}

#pragma maek - setter

- (void)setURLString:(NSString *)URLString
{
    _URLString = URLString;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 异步操作
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
        
        if (!data) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 主线程更新
            _adImageView.alpha = 1.0;
            _adImageView.image = [UIImage imageWithData:data];
            
            DrawCircleProgressButton *drawCircleView = [[DrawCircleProgressButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 55, 30, 30, 30)];
            [drawCircleView setTitle:@"跳过" forState:UIControlStateNormal];
            [drawCircleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            drawCircleView.trackColor = [UIColor blackColor];
            drawCircleView.titleLabel.font = [UIFont systemFontOfSize:12];
            drawCircleView.lineWidth = 2;
            [drawCircleView addTarget:self action:@selector(removeProgress) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:drawCircleView];
            __weak typeof(self)  weakSelf = self;
            [drawCircleView startAnimationDuration:3.0 withBlock:^{
                [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [weakSelf removeFromSuperview];
                }];
          
            }];
        });
    });
}

-(void) removeProgress
{
    [self removeFromSuperview];

}

#pragma mark - action

- (void)singleTapGesture:(UITapGestureRecognizer *)recognizer
{
//    if (self.clickedImageURLHandle) {
//        self.clickedImageURLHandle(self.URLString);
//    }
//    if (self.superview) {
//        [self removeFromSuperview];
//    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden == NO && _adImageView.alpha > 0 && CGRectContainsPoint(_adImageView.frame, point)) {
        return self;
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _adImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)*0.86);
}


@end
