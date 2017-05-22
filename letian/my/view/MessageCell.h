//
//  MessageCell.h
//  letian
//
//  Created by 郭茜 on 2017/3/9.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *msgDetailLabel;

+(instancetype) cellWithTableView:(UITableView *)tableView;

@end
