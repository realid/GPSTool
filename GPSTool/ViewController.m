//
//  ViewController.m
//  GPSTool
//
//  Created by 李丹 on 15/4/8.
//  Copyright (c) 2015年 cloudmyself.net. All rights reserved.
//

#import "ViewController.h"
#import "NMEA0183.h"
#import "GPX.h"

@interface ViewController ()

@property (strong, nonatomic)NSMutableArray *gpsInfos;
@property (strong, nonatomic)NSMutableArray *fileURLs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gpsInfos = [NSMutableArray array];
}

- (IBAction)browseButtonClicked:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    panel.allowedFileTypes = [NSArray arrayWithObjects:@"log", nil];
    if ([panel runModal] == NSFileHandlingPanelCancelButton)
        return;
    self.fileURLs = [NSMutableArray arrayWithArray:panel.URLs];
    NSMutableString *contentString = [NSMutableString stringWithString:[self.fileURLs[0] lastPathComponent]];
    for (int i = 1; i < self.fileURLs.count; i++) {
        [contentString appendString:@";"];
        [contentString appendString:[self.fileURLs[i] lastPathComponent]];
    }
    [self.browseField setStringValue:contentString];
}

- (IBAction)saveToGPXButtonClicked:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories: YES];
    [panel setCanChooseFiles: NO];
    panel.canCreateDirectories = YES;
    panel.allowsOtherFileTypes = YES;
    if ([panel runModal] == NSFileHandlingPanelCancelButton)
        return;
    [self.saveGpxFiled setStringValue: panel.URL.absoluteString];
    
    for (int i = 0; i < self.fileURLs.count; i++) {
        NSString *filename = [[self.fileURLs[i] lastPathComponent] stringByReplacingOccurrencesOfString:@"log" withString:@"gpx"];
        NSURL *savePath = [panel.URL URLByAppendingPathComponent:filename];
        NSLog(@"%@", savePath);
        NMEA0183 *nmea = [NMEA0183 nmea0183WithURL:self.fileURLs[i]];
        if (!nmea)
            continue;
        GPX *gpx = [GPX gpxWithNMEA0183:nmea];
        if (!gpx)
            continue;
        [gpx saveToURL:savePath];
    }
    
}

- (IBAction)saveOneFile:(id)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setCanCreateDirectories:YES];
    panel.showsTagField = NO;
    if ([panel runModal] == NSFileHandlingPanelCancelButton)
        return;
    NSString *filename = [[panel.URL lastPathComponent] stringByAppendingString:@".gpx"];
    [self.saveGpxFiled setStringValue:filename];
    NMEA0183 *nmea = [NMEA0183 nmea0183WithURLs:self.fileURLs];
    if (!nmea)
        return;
    GPX *gpx = [GPX gpxWithNMEA0183:nmea];
    if (!gpx)
        return;
    [gpx saveToURL:panel.URL];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
