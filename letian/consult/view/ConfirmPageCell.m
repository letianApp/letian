//
//  ConfirmPageCell.m
//  letian
//
//  Created by J on 2017/3/9.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ConfirmPageCell.h"

@implementation ConfirmPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customCell];
    
}

- (void)customCell {
    
    self.mainColorTag.backgroundColor = MAINCOLOR;
    self.labelTag.font = [UIFont boldSystemFontOfSize:15];
    self.detialLab.numberOfLines = 0;
    self.detialLab.font = [UIFont systemFontOfSize:13];
    self.detialLab.textColor = [UIColor darkGrayColor];
    
}


+ (instancetype) cellWithTableView:(UITableView *)tableView {
    
    ConfirmPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfirmPageCell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConfirmPageCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
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
