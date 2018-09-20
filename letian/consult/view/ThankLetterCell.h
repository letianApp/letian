//
//  ThankLetterCell.h
//  letian
//
//  Created by J on 2018/9/3.
//  Copyright © 2018年 J. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThankLetterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;


//+ (instancetype) cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
