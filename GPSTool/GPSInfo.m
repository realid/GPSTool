//
//  GPSInfo.m
//  GPSTool
//
//  Created by 李丹 on 15/4/9.
//  Copyright (c) 2015年 cloudmyself.net. All rights reserved.
//

#import "GPSInfo.h"

@implementation GPSInfo

// NMEA的经度格式为dddmm.mmmm，纬度格式为ddmm.mmmm，需要转换成ddd.dddd格式保存
+ (instancetype)gpsInfoWithGPGGA:(NSString *)GPGGA AndGPRMC:(NSString *)GPRMC {
    GPSInfo* gpsInfo = [[GPSInfo alloc] init];
    if (gpsInfo) {
        NSArray *GPGGAArray = [GPGGA componentsSeparatedByString:@","];
        NSArray *GPRMCArray = [GPRMC componentsSeparatedByString:@","];
        // 定位状态
        gpsInfo.status = [NSNumber numberWithChar:[GPRMCArray[2] cStringUsingEncoding:NSUTF8StringEncoding][0]];
        
        // 纬度
        NSRange degreesRange;
        degreesRange.location = 0;
        degreesRange.length = 2;
        double degrees = [[GPRMCArray[3] substringWithRange:degreesRange] doubleValue];
        NSRange minuteRange;
        minuteRange.location = 2;
        minuteRange.length = 7;
        double minute = [[GPRMCArray[3] substringWithRange:minuteRange] doubleValue];
        degrees += minute / 60;
        if ([GPRMCArray[4] isEqualToString:@"S"])
            degrees = -degrees;
        gpsInfo.latitude = [NSNumber numberWithDouble:degrees];
        
        // 经度
        degreesRange.location = 0;
        degreesRange.length = 3;
        degrees = [[GPRMCArray[5] substringWithRange:degreesRange] doubleValue];
        minuteRange.location = 3;
        minuteRange.length = 7;
        minute = [[GPRMCArray[5] substringWithRange:minuteRange] doubleValue];
        degrees += minute / 60;
        if ([GPRMCArray[6] isEqualToString:@"W"])
            degrees = -degrees;
        gpsInfo.longitude = [NSNumber numberWithDouble:degrees];
        
        // 高度
        gpsInfo.high = [NSNumber numberWithDouble:[GPGGAArray[9] doubleValue]];
        
        // 时间
        NSRange range;
        range.location = 0;
        range.length = 6;
        NSString *time = [NSString stringWithFormat:@"%@%@", GPRMCArray[9], [GPRMCArray[1] substringWithRange:range]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"ddMMyyHHmmss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        gpsInfo.D = [dateFormatter dateFromString:time];
    }

    return gpsInfo;
}

@end
