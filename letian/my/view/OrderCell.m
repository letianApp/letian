//
//  OrderCell.m
//  letian
//
//  Created by 郭茜 on 2017/3/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *wayLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *stateButton;



@end

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.stateButton.layer.borderColor=MAINCOLOR.CGColor;
    self.stateButton.layer.borderWidth=0.8;
    self.stateButton.layer.masksToBounds=YES;
    self.stateButton.layer.cornerRadius=8;
    
    
    
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
