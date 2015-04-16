//
//  GPXSave.m
//  GPSTool
//
//  Created by 李丹 on 15/4/13.
//  Copyright (c) 2015年 cloudmyself.net. All rights reserved.
//

#import "GPX.h"
#import "GPSInfo.h"
#import "NMEA0183.h"

@interface GPX ()

@property (strong, nonatomic) NSData *xmlData;

@end

@implementation GPX

+ (instancetype)gpxWithNMEA0183:(NMEA0183 *)nmea {
    if (nmea.gpsinfos.count <= 0)
        return nil;
    GPX *gpx = [[GPX alloc] init];
    if (gpx) {
        NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"gpx"];
        [root addAttribute:[NSXMLNode attributeWithName:@"version" stringValue:@"1.1"]];
        [root addAttribute:[NSXMLNode attributeWithName:@"creator" stringValue:@"GPSTool 1.0b1 - http://www.topografix.com"]];
        [root addAttribute:[NSXMLNode attributeWithName:@"xmlns:xsi" stringValue:@"http://www.w3.org/2001/XMLSchema-instance"]];
        [root addAttribute:[NSXMLNode attributeWithName:@"xmlns" stringValue:@"http://www.topografix.com/GPX/1/1"]];
        [root addAttribute:[NSXMLNode attributeWithName:@"xmlns:topografix" stringValue:@"http://www.topografix.com/GPX/Private/TopoGrafix/0/1"]];
        [root addAttribute:[NSXMLNode attributeWithName:@"xsi:schemaLocation" stringValue:@"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd"]];
        NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
        [xmlDoc setVersion:@"1.0"];
        [xmlDoc setCharacterEncoding:@"UTF-8"];
        [xmlDoc setStandalone:YES];
        
        NSXMLElement *trk = [NSXMLNode elementWithName:@"trk"];
        [root addChild:trk];
//        NSXMLElement *name = [NSXMLNode elementWithName:@"name" stringValue:fileName];
//        [trk addChild:name];
        NSXMLElement *trkseg = [NSXMLNode elementWithName:@"trkseg"];
        [trk addChild:trkseg];
        for (int i = 0; i < nmea.gpsinfos.count; i++) {
            NSXMLElement *trkpt = [NSXMLNode elementWithName:@"trkpt"];
            
            // latitude longitude
            // 输出精确到小数点后10位
            NSString *latitudeString = [NSString stringWithFormat:@"%.10f", [[nmea.gpsinfos[i] latitude] doubleValue]];
            [trkpt addAttribute:[NSXMLNode attributeWithName:@"lat" stringValue:latitudeString]];
            NSString *longitudeString = [NSString stringWithFormat:@"%.10f", [[nmea.gpsinfos[i] longitude] doubleValue]];
            [trkpt addAttribute:[NSXMLNode attributeWithName:@"lon" stringValue:longitudeString]];
            [trkseg addChild:trkpt];
            
            // high
            NSXMLElement *ele = [NSXMLNode elementWithName:@"ele" stringValue:[[nmea.gpsinfos[i] high] stringValue]];
            [trkpt addChild:ele];
            
            NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
            [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
            [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            NSXMLElement *time = [NSXMLNode elementWithName:@"time" stringValue:[rfc3339DateFormatter stringFromDate:[nmea.gpsinfos[i] D]]];
            [trkpt addChild:time];
        }
        gpx.xmlData = [xmlDoc XMLDataWithOptions:NSXMLNodePrettyPrint];
    }
    
    return gpx;
}

- (BOOL)saveToURL:(NSURL *)url {
    return [self.xmlData writeToURL:url atomically:YES];
}

@end
