//
//  NSString+YYExtension.h
//  cheyongwang
//
//  Created by 恽雨晨 on 15/11/14.
//  Copyright © 2015年 恽雨晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YYExtension)

-(NSInteger) fileSize;

+ (NSString *)documentPath;
+ (NSString *)cachePath;
+ (NSString *)formatCurDate;
+ (NSString *)formatCurDay;
+ (NSString *)getAppVer;
+(NSString*)DataTOjsonString:(id)object;
- (NSString*)removeAllSpace;
- (NSURL *) toURL;
- (NSString *) escapeHTML;
- (NSString *) unescapeHTML;
- (NSString *) stringByRemovingHTML;
- (NSString *) MD5;
- (NSString *) URLEncode;
- (NSString *) trim;
- (NSString *)changeToHexFromString;  //从普通字符串转换为16进制
- (NSString *)changeToStringFromHex;    //从16进制转化为普通字符串
//获取当前的时间戳
+(NSString *) timestamp;
- (NSString *)changeToDecimalFromHex;  //从16进制转换为10进制
+ (NSString *)HMACMD5WithString:(NSString *)toEncryptStr WithKey:(NSString *)keyStr;
- (NSString *)YYApi_SHA1Encryption:(NSString *)nonce timeSp:(NSString *)timeSp;
//生成随机数
+(NSString *)randomString;
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (BOOL) isOlderVersionThan:(NSString*)otherVersion;
- (BOOL) isNewerVersionThan:(NSString*)otherVersion;
- (BOOL) isEmail;
- (BOOL) isEmpty;
@end
