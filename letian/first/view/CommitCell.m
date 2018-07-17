//
//  CommitCell.m
//  letian
//
//  Created by J on 2018/7/11.
//  Copyright © 2018年 J. All rights reserved.
//

#import "CommitCell.h"

@implementation CommitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.headImg.size = CGSizeMake(45, 45);
    self.headImg.layer.cornerRadius = self.headImg.frame.size.width / 2;
    self.headImg.clipsToBounds      = YES;
    self.headImg.contentMode        = UIViewContentModeScaleToFill;
    
}


+ (instancetype) cellWithTableView:(UITableView *)tableView {
    
    CommitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commitCell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commitCell"];
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
