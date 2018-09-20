//
//  SpecialCollectionViewCell.m
//  letian
//
//  Created by J on 2018/9/10.
//  Copyright © 2018年 J. All rights reserved.
//

#import "SpecialCollectionViewCell.h"

@implementation SpecialCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOpacity = 0.8f;
    self.bgView.layer.shadowRadius = 2.f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.bgView.layer.cornerRadius = 5.f;
    
}



@end
