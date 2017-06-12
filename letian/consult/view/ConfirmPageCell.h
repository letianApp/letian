//
//  ConfirmPageCell.h
//  letian
//
//  Created by J on 2017/3/9.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainColorTag;
@property (weak, nonatomic) IBOutlet UILabel *labelTag;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *detialLab;


//+ (instancetype) cellWithTableView:(UITableView *)tableview;
+ (instancetype) cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;


@end
