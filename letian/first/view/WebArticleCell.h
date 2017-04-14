//
//  WebArticleCell.h
//  letian
//
//  Created by 郭茜 on 2017/4/14.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebArticleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *readNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

+(instancetype) cellWithTableView:(UITableView *)tableView;

@end
