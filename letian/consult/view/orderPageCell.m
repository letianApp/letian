//
//  orderPageCell.m
//  letian
//
//  Created by J on 2017/3/7.
//  Copyright © 2017年 J. All rights reserved.
//

#import "orderPageCell.h"

@implementation orderPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.userInteractionEnabled = NO;
    [self customLab];
    
}

- (void)customLab {
    
    self.textLab.numberOfLines = 0;
    self.textLab.font = [UIFont systemFontOfSize:12];
    self.textLab.textColor = [UIColor darkGrayColor];
    
}




+ (instancetype) cellWithTableView:(UITableView *)tableView
{
    orderPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderPageCell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderPageCell"];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
