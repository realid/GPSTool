//
//  GPXSave.h
//  GPSTool
//
//  Created by 李丹 on 15/4/13.
//  Copyright (c) 2015年 cloudmyself.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMEA0183;

@interface GPX : NSObject

+ (instancetype)gpxWithNMEA0183:(NMEA0183 *)nmea;
- (BOOL)saveToURL:(NSURL *)url;

@end
