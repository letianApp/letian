//
//  consultPageCell.m
//  letian
//
//  Created by J on 2017/2/28.
//  Copyright © 2017年 J. All rights reserved.
//

#import "consultPageCell.h"

@implementation consultPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customCell];
    [self test];
    
}

# pragma mark 定制cell
- (void)customCell {
    
    self.conselorImage.layer.cornerRadius = self.conselorImage.frame.size.width / 2;
    self.conselorImage.clipsToBounds=YES;
    self.conselorName.textColor = MAINCOLOR;
    self.conselorName.font = [UIFont boldSystemFontOfSize:15];
    self.conselorStatus.textColor = [UIColor lightGrayColor];
    self.conserlorAbout.numberOfLines = 0;
    self.conserlorAbout.font = [UIFont systemFontOfSize:12];
    self.conserlorAbout.textColor = [UIColor lightGrayColor];
    
}

//测试数据
- (void)test {
    
    self.conselorImage.image = [UIImage imageNamed:@"wowomen"];
    self.conserlorSex.image = [UIImage imageNamed:@"female"];
    self.conselorName.text = @"孙晓平";
    self.conselorStatus.text = @"专家心理咨询师";
    self.conserlorAbout.text = @"毕业于山东大学，国家二级心理咨询师，心理动力学取向。持续接受精神分析系统培训，长期接受心理动力学取向案例督导及个人体验。咨询风格亲和包容。咨询理念：跟随心的指引，勇敢面对真实";
    self.conserlorPrice.text = @"800元/小时，4小时以上88折，8小时88折赠送1小时";
    self.conserVisitors.text = @"200人咨询过";

}

+ (instancetype) cellWithTableView:(UITableView *)tableView
{
    consultPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"counselorCell"];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"counselorCell"];
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
