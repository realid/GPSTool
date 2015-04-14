//
//  NMEA0183.m
//  GPSTool
//
//  Created by 李丹 on 15/4/13.
//  Copyright (c) 2015年 cloudmyself.net. All rights reserved.
//

#import "NMEA0183.h"
#import "GPSInfo.h"


@implementation NMEA0183

+ (instancetype)nmea0183WithURL:(NSURL *)url {
    NSString *fileString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (!fileString)
        return nil;
    
    NMEA0183 *nmea = [[NMEA0183 alloc] init];
    if (nmea) {
        const char *string = fileString.UTF8String;
        char szBuf[128];
        memset(szBuf, 0, sizeof(szBuf));
        // 检查文件第一行判断是否为CanonGPS生成
        char *pos = strstr(string, "\r\n");
        memcpy(szBuf, string, pos-string);
        if (strncmp(szBuf, "@CanonGPS", strlen("@CanonGPS")) != 0) {
            NSLog(@"Error file format");
            return nil;
        }
        
        nmea.gpsinfos = [[NSMutableArray alloc] init];
        
        pos = pos + 2;
        char *next = pos;
        // 解析GPGPA和GPRMC数据，并保存到GPSInfo中
        while ((next = strstr(pos, "\r\n"))) {
            memset(szBuf, 0, sizeof(szBuf));
            memcpy(szBuf, pos, next-pos);
            NSString *GPGGA = [NSString stringWithUTF8String:szBuf];
            pos = next+2;
            next = strstr(pos, "\r\n");
            memset(szBuf, 0, sizeof(szBuf));
            memcpy(szBuf, pos, next-pos);
            NSString *GPRMC = [NSString stringWithUTF8String:szBuf];
            pos = next+2;
            GPSInfo *gpsinfo = [GPSInfo gpsInfoWithGPGGA:GPGGA AndGPRMC:GPRMC];
            if (!gpsinfo) {
                NSLog(@"Error GPGPA/GPRMC data");
                continue;
            }
            [nmea.gpsinfos addObject:gpsinfo];
        }
    }
    
    return nmea;
}

@end
