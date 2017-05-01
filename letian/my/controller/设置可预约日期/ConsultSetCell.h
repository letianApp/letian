//
//  ConsultSetCell.h
//  letian
//
//  Created by 吴乐东 on 2017/5/1.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultSetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *isEnableConsultLab;
@property (weak, nonatomic) IBOutlet UISwitch *isEnableSwitch;
@property (weak, nonatomic) IBOutlet UILabel *setTimeTitleLab;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;





+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
