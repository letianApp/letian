//
//  ApiDoctorConsultDateModel.h
//  letian
//
//  Created by 郭茜 on 2017/5/8.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConsultTimeArray;
@interface ConsultDateModel : NSObject

@property (nonatomic,copy) NSString *CousultDate;

@property (nonatomic,copy) NSString *IsEnableConsult;


@property (nonatomic,strong) NSArray <ConsultTimeArray *> *ConsultTimeList;

@end


@interface ConsultTimeArray : NSObject

@property (nonatomic,copy) NSString *StartTime;

@property (nonatomic,copy) NSString *EndTime;

@end
