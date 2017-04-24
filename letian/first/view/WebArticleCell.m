//
//  WebArticleCell.m
//  letian
//
//  Created by 郭茜 on 2017/4/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import "WebArticleCell.h"

@implementation WebArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.masksToBounds=YES;
    self.bgView.layer.cornerRadius=8;
    self.bgView.layer.borderWidth=1;
    self.bgView.layer.borderColor=[MAINCOLOR CGColor] ;
    self.bgView.alpha=0.5;
    // Initialization code
}


+(instancetype) cellWithTableView:(UITableView *)tableView
{
    WebArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
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
