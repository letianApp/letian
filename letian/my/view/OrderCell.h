//
//  OrderCell.h
//  letian
//
//  Created by 郭茜 on 2017/3/13.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property(nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger secondsCountDown;
@property (weak, nonatomic) IBOutlet UILabel *timeChangeLabel;

+(instancetype) cellWithTableView:(UITableView *)tableView;

@end
