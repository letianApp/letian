//
//  ThankLetterCell.m
//  letian
//
//  Created by J on 2018/9/3.
//  Copyright © 2018年 J. All rights reserved.
//

#import "ThankLetterCell.h"
#import "Colours.h"


@implementation ThankLetterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customCell];
}

- (void)customCell {
    
    self.bgView.backgroundColor = [UIColor coralColor];
    self.backgroundColor = [UIColor easterPinkColor];
//    self.headImg.backgroundColor = [UIColor blackColor];
    self.headImg.layer.cornerRadius = 20.f;
    self.headImg.clipsToBounds = YES;
    self.headImg.contentMode = UIViewContentModeScaleAspectFill;
    self.nameLab.font = [UIFont boldSystemFontOfSize:15];
    self.nameLab.textColor = [UIColor whiteColor];
    self.detailLab.font = [UIFont systemFontOfSize:14];
    self.detailLab.textColor = [UIColor whiteColor];
    self.timeLab.font = [UIFont systemFontOfSize:14];
    self.timeLab.textColor = [UIColor lightTextColor];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
