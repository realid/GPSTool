//
//  GPSInfo.h
//  GPSTool
//
//  Created by 李丹 on 15/4/9.
//  Copyright (c) 2015年 cloudmyself.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSInfo : NSObject
@property NSDate     *D;          // 时间
@property NSNumber   *status;     // 接收状态
@property NSNumber   *latitude;   // 纬度
@property NSNumber   *longitude;  // 经度
@property NSNumber   *high;       // 高度

+ (instancetype)gpsInfoWithGPGGA:(NSString *)GPGGA AndGPRMC:(NSString *)GPRMC;

@end