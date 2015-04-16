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

+ (instancetype)nmea0183WithURLs:(NSArray *)urls {
    NMEA0183 *nmea = [[NMEA0183 alloc] init];
    if (nmea) {
        nmea.gpsinfos = [[NSMutableArray alloc] init];
        for (int i = 0; i < urls.count; i++) {
            NSString *fileString = [NSString stringWithContentsOfURL:urls[i] encoding:NSUTF8StringEncoding error:nil];
            if (!fileString)
                continue;
            NSArray *nmeaLines = [fileString componentsSeparatedByString:@"\r\n"];
            NSRange range = [nmeaLines[0] rangeOfString:@"CanonGPS"];
            if (range.location == NSNotFound || range.location != 1) {
                NSLog(@"Error file format: %@", [urls[i] absoluteString]);
                continue;
            }
            for (int j = 1; j < nmeaLines.count-2; j+=2) {
                GPSInfo *gpsInfo = [GPSInfo gpsInfoWithGPGGA:nmeaLines[j] AndGPRMC:nmeaLines[j+1]];
                if (gpsInfo)
                    [nmea.gpsinfos addObject:gpsInfo];
            }
        }
    }
    
    return nmea;
}

+ (instancetype)nmea0183WithURL:(NSURL *)url {
    NSString *fileString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (!fileString)
        return nil;
    
    NMEA0183 *nmea = [[NMEA0183 alloc] init];
    if (nmea) {
        nmea.gpsinfos = [[NSMutableArray alloc] init];
        NSString *fileString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        if (!fileString)
            return nil;
        NSArray *nmeaLines = [fileString componentsSeparatedByString:@"\r\n"];
        NSRange range = [nmeaLines[0] rangeOfString:@"CanonGPS"];
        if (range.location == NSNotFound || range.location != 1) {
            NSLog(@"Error file format: %@", [url absoluteString]);
            return nil;
        }
        for (int i = 1; i < nmeaLines.count-2; i+=2) {
            GPSInfo *gpsInfo = [GPSInfo gpsInfoWithGPGGA:nmeaLines[i] AndGPRMC:nmeaLines[i+1]];
            if (gpsInfo)
                [nmea.gpsinfos addObject:gpsInfo];
        }
    }
    
    return nmea;
}

@end
