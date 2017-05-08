//
//  OrderConsultCell.h
//  letian
//
//  Created by 郭茜 on 2017/5/7.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConsultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImgView;

@property (weak, nonatomic) IBOutlet UILabel *doctorNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *consultTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *consultTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImgView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;

@property (weak, nonatomic) IBOutlet UILabel *consultDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;


@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
