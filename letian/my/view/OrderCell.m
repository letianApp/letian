//
//  OrderCell.m
//  letian
//
//  Created by 郭茜 on 2017/3/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype) cellWithTableView:(UITableView *)tableView
{
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    cell.bgView.layer.borderWidth=1;
//    cell.bgView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
//    cell.bgView.layer.masksToBounds=YES;
//    cell.bgView.layer.cornerRadius=8;
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
