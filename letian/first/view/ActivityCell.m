//
//  ActivityCell.m
//  letian
//
//  Created by 郭茜 on 2017/5/11.
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
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:cell.ActivityImageView.bounds];
    toolbar.barStyle = UIBarStyleBlackOpaque;
    toolbar.alpha=0.7;
    [cell.ActivityImageView addSubview:toolbar];
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
