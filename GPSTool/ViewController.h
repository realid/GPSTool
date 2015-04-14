//
//  ViewController.h
//  GPSTool
//
//  Created by 李丹 on 15/4/8.
//  Copyright (c) 2015年 cloudmyself.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTextField *browseField;
@property (weak) IBOutlet NSTextField *saveGpxFiled;

@end

