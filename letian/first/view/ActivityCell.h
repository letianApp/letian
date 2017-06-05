//
//  ActivityCell.h
//  letian
//
//  Created by 郭茜 on 2017/6/5.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+(instancetype) cellWithTableView:(UITableView *)tableView;

@end
