//
//  ApiDoctorConsultDateModel.h
//  letian
//
//  Created by 郭茜 on 2017/5/8.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConsultTimeList;
@interface ApiDoctorConsultDateModel : NSObject

@property (nonatomic,copy) NSString *CousultDate;

@property (nonatomic,assign) BOOL IsEnableConsult;


@property (nonatomic,strong) NSArray <ConsultTimeList *> *DoctorConsultTime;

@end


@interface ConsultTimeList : NSObject

@property (nonatomic,copy) NSString* StartTime;

@property (nonatomic,copy) NSString* EndTime;

@end
