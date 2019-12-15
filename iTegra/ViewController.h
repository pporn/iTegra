//
//  ViewController.h
//  iTegra
//
//  Created by Chen Yang on 12/14/19.
//  Copyright © 2019 Chen Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RcmMonitor.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *lbModeIndicator;
@property (weak) IBOutlet NSButtonCell *btnInjectPayload;
@property (weak) IBOutlet NSTextField *tbFilePath;

@property (strong, nonatomic) NSData* relocator;
@property (strong, nonatomic) RcmMonitor* rcmMonitor;


@property (assign) BOOL isRCMDeviceConnected;

@end

