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
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
//    label.backgroundColor = MAINCOLOR;
    [_bgImg addSubview:label];
    _label = label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _label.frame = self.bounds;
    _bgImg.frame = self.contentView.bounds;
    _bgImg.clipsToBounds = YES;
    _bgImg.layer.cornerRadius = 5.f;
    
    _label.frame = CGRectMake(_bgImg.width/5, _bgImg.height*4/5, _bgImg.width*4/5, _bgImg.height/5);

//    UIView *shadow = [[UIView alloc] initWithFrame:self.contentView.bounds];
//    [_bgImg.superview insertSubview:shadow aboveSubview:_bgImg];
//    shadow.layer.shadowColor = [UIColor blackColor].CGColor;
//    shadow.layer.shadowOpacity = 0.8f;
//    shadow.layer.shadowRadius = 8.f;
//    shadow.layer.shadowOffset = CGSizeMake(0, 0);
//    [shadow mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.left.bottom.top.equalTo(_bgImg);
//    }];
    
}

@end
