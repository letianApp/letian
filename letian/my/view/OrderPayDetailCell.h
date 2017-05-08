//
//  OrderPayDetailCell.h
//  letian
//
//  Created by 郭茜 on 2017/5/7.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPayDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *PayTypeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *PayTypeImgView;

@property (weak, nonatomic) IBOutlet UILabel *PayTimeLabel;

+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
