//
//  HomeCell.m
//  letian
//
//  Created by 郭茜 on 2017/2/27.
//  Copyright © 2017年 J. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype) cellWithTableView:(UITableView *)tableView
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailLabel.textColor = [UIColor lightGrayColor];
    cell.detailLabel.numberOfLines = 2;
    cell.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.headImageView.clipsToBounds = YES;
    cell.separatView.backgroundColor = MAINCOLOR;
    
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
