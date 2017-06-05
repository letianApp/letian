//
//  ActivityCell.m
//  letian
//
//  Created by 郭茜 on 2017/6/5.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype) cellWithTableView:(UITableView *)tableView
{
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActivityCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=[UIColor whiteColor];
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
