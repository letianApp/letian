//
//  OrderCell.m
//  letian
//
//  Created by 郭茜 on 2017/3/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell()

@end

@implementation OrderCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.stateButton.layer.borderColor=[UIColor clearColor].CGColor;
    self.stateButton.layer.borderWidth=0.8;
    self.stateButton.layer.masksToBounds=YES;
    self.stateButton.layer.cornerRadius=8;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
    
    self.timeChangeLabel.hidden=YES;
}

+(instancetype) cellWithTableView:(UITableView *)tableView
{
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{//取消cell的复用
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
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



-(void)countDownAction{
    self.secondsCountDown--;
//    NSString *str_hour = [NSString stringWithFormat:@"%02ld",self.secondsCountDown/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(self.secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",self.secondsCountDown%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    self.timeChangeLabel.text=[NSString stringWithFormat:@"%@内未支付，该订单将失效",format_time];
    if(self.secondsCountDown<=0){
        [self.timer invalidate];
        self.timeChangeLabel.text=@"";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
