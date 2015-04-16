//
//  NMEA0183.h
//  GPSTool
//
//  Created by 李丹 on 15/4/13.
//  Copyright (c) 2015年 cloudmyself.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMEA0183 : NSObject

@property (strong, nonatomic) NSMutableArray *gpsinfos;

+ (instancetype)nmea0183WithURL:(NSURL *)url;
+ (instancetype)nmea0183WithURLs:(NSArray *)urls;

@end
