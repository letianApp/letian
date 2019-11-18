//
//  FeeModel.h
//  letian
//
//  Created by Guoqian on 2019/11/12.
//  Copyright © 2019 J. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeeModel : NSObject
//@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,copy)NSString *MinFee;
@property (nonatomic,copy)NSString *Name;
@property (nonatomic,copy)NSString *MaxFee;
@property (nonatomic,assign)NSInteger OrderNum;
@end

NS_ASSUME_NONNULL_END
