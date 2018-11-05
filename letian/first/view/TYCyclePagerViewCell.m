//
//  TYCyclePagerViewCell.m
//  letian
//
//  Created by J on 2018/10/29.
//  Copyright © 2018 J. All rights reserved.
//

#import "TYCyclePagerViewCell.h"

@interface TYCyclePagerViewCell ()
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIImageView *bgImg;

@end

@implementation TYCyclePagerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self addLabel];
    }
    return self;
}


- (void)addLabel {
    UIImageView *bgImg = [[UIImageView alloc]init];
    bgImg.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:bgImg];
    _bgImg = bgImg;
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = MAINCOLOR;
    [_bgImg addSubview:label];
    _label = label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _label.frame = self.bounds;
    _bgImg.frame = self.contentView.bounds;
    _bgImg.clipsToBounds = YES;
    _bgImg.layer.shadowColor = [UIColor blackColor].CGColor;
    _bgImg.layer.shadowOpacity = 0.8f;
    _bgImg.layer.shadowRadius = 2.f;
    _bgImg.layer.shadowOffset = CGSizeMake(0, 0);
    _bgImg.layer.cornerRadius = 5.f;
    _label.bottom = _bgImg.bottom;
    
}

@end
