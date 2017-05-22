//
//  SystemMsgModel.h
//  letian
//
//  Created by 郭茜 on 2017/5/19.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMsgModel : NSObject

@property (nonatomic,copy) NSString *Remark;

@property (nonatomic,copy) NSString *CreatedDate;

@property (nonatomic,copy) NSString *Title;

@property (nonatomic,assign) NSInteger MessageTypeID;

@property (nonatomic,assign) NSInteger UserID;

@property (nonatomic,assign) NSInteger RefferID2;

@property (nonatomic,assign) NSInteger RefferID1;

@property (nonatomic,assign) NSInteger ID;




@end
