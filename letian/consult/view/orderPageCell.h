//
//  orderPageCell.h
//  letian
//
//  Created by J on 2017/3/7.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderPageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLab;




+ (instancetype) cellWithTableView:(UITableView *)tableview;

@end
