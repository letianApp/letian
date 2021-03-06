//
//  MessageCell.m
//  letian
//
//  Created by 郭茜 on 2017/3/9.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()



@end

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(instancetype) cellWithTableView:(UITableView *)tableView
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.bgView.layer.borderWidth=0.5;
    cell.bgView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    cell.bgView.layer.masksToBounds=YES;
    cell.bgView.layer.cornerRadius=8;
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
