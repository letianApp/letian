//
//  OrderPayDetailCell.m
//  letian
//
//  Created by 郭茜 on 2017/5/7.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderPayDetailCell.h"

@implementation OrderPayDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    OrderPayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayDetailCell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderPayDetailCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

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
