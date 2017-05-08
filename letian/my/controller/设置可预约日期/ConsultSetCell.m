//
//  ConsultSetCell.m
//  letian
//
//  Created by 吴乐东 on 2017/5/1.
//  Copyright © 2017年 J. All rights reserved.
//

#import "ConsultSetCell.h"


#import "SnailPopupController.h"


@implementation ConsultSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customCell];
    
}

- (void)customCell {
    
    self.isEnableConsultLab.font = [UIFont systemFontOfSize:15];
    self.isEnableSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    self.isEnableSwitch.onTintColor = MAINCOLOR;
    
    self.setTimeTitleLab.font = [UIFont systemFontOfSize:15];
    
    self.startTimeBtn.layer.borderColor = MAINCOLOR.CGColor;
    self.startTimeBtn.layer.borderWidth = 1;
    self.startTimeBtn.layer.cornerRadius = 15;
    [self.startTimeBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    
    self.endTimeBtn.layer.borderColor = MAINCOLOR.CGColor;
    self.endTimeBtn.layer.borderWidth = 1;
    self.endTimeBtn.layer.cornerRadius = 15;
    self.endTimeBtn.titleLabel.textColor = MAINCOLOR;
    [self.endTimeBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];

    
    
    
}

- (IBAction)clickStartTimeBtn:(id)sender {
    
    UIView *view = [[UIView alloc]init];
//    UIButton *btn = sender;
    
    NSLog(@"点击aa");
    [self animationbegin:sender];
    
    self.sl_popupController                          = [[SnailPopupController alloc] init];
    self.sl_popupController.layoutType               = PopupLayoutTypeCenter;
    self.sl_popupController.maskType                 = PopupMaskTypeWhiteBlur;
    self.sl_popupController.transitStyle             = PopupTransitStyleSlightScale;
    self.sl_popupController.dismissOppositeDirection = YES;

    [self.sl_popupController presentContentView:view];

    
}

- (IBAction)clickEndTimeBtn:(id)sender {
    
    NSLog(@"点击bb");
    [self animationbegin:sender];

    
}





#pragma mark 按钮动画
- (void)animationbegin:(UIView *)view {
    /* 放大缩小 */
    
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ConsultSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConsultSetCell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConsultSetCell"];
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
