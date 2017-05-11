//
//  ActivityCell.h
//  letian
//
//  Created by 郭茜 on 2017/5/11.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ActivityImageView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+(instancetype) cellWithTableView:(UITableView *)tableView;

@end
