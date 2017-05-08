//
//  OrderMoneyCell.h
//  letian
//
//  Created by 郭茜 on 2017/5/7.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMoneyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
