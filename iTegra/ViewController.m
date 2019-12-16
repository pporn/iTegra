//
//  ViewController.m
//  iTegra
//
//  Created by Chen Yang on 12/14/19.
//  Copyright © 2019 Chen Yang. All rights reserved.
//

#import "ViewController.h"
#import "RcmMonitor.h"

@implementation ViewController


- (void)viewWillAppear {
    [self setIsRCMDeviceConnected: YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register the notification event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceIsConnected) name:@"deviceConnected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceIsDisconnected) name:@"deviceDisconnected" object:nil];

    // get relocator
    NSString *relocatorPath = [[NSBundle mainBundle] pathForResource:@"intermezzo" ofType:@"bin"];
    [self setRelocator:[NSData dataWithContentsOfFile:relocatorPath]];

    // start rcm monitor thread
    self.rcmMonitor = [[RcmMonitor alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.rcmMonitor start];
        CFRunLoopRun();
    });
}

- (void) viewDidAppear {
}

- (void)viewWillDisappear {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void) setLabel:(BOOL)isAvailable {
    if(isAvailable) {
        [self.lbModeIndicator setTextColor: [NSColor systemGreenColor]];
        [self.lbModeIndicator setStringValue:@"RCM mode Switch detected!"];
    } else {
        [self.lbModeIndicator setTextColor: [NSColor systemRedColor]];
        [self.lbModeIndicator setStringValue:@"No RCM mode Switch detected!"];
    }
}

- (void) deviceIsConnected {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setIsRCMDeviceConnected: YES];
        [self setLabel:YES];
        [self.btnInjectPayload setEnabled:YES];
    });
}

- (void) deviceIsDisconnected {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.btnInjectPayload setEnabled:NO];
        [self setLabel:NO];
        [self setIsRCMDeviceConnected: NO];
    });
}

- (IBAction)btnOpenClicked:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];

    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseDirectories:NO];

    if([openPanel runModal] == NSModalResponseOK) {
        NSURL* filePath = openPanel.URL;
        // validate file path
        if(filePath != nil && [filePath isFileURL]) {
            [self.tbFilePath setStringValue: [filePath path]];
        }
    }
}

- (IBAction)btnInjectPayloadClicked:(id)sender {
    if(![self isRCMDeviceConnected]) {
        return;
    }
    
    NSAlert* alert = [[NSAlert alloc] init];

    // get relocator image
    if([self relocator] == nil) {
        [alert setMessageText:@"Error"];
        [alert setInformativeText:@"Cannot find relocator image"];
        [alert runModal];

        return;
    }
    // get payload image
    NSData* payload = [NSData dataWithContentsOfFile:[self.tbFilePath stringValue]];
    if(payload == nil) {
        [alert setMessageText:@"Error"];
        [alert setInformativeText:@"Cannot open payload"];
        [alert runModal];

        return;
    }

    // for error message
    NSString *err = nil;

    // grab usb descriptor
    struct NXExecDesc desc = NXExecAcquireDeviceInterface(self.rcmMonitor.usbDevice->_intf, &err);
    if(desc.intf == nil) {
        [alert setMessageText:@"Error"];
        [alert setInformativeText:@"Cannot acquire USB interface!"];
        [alert runModal];
        
        return;
    }
    if(NXExecDesc(&desc, self.relocator, payload, &err)) {
        [alert setMessageText:@"Success"];
        [alert setInformativeText:@"Payload has been injected!"];
        [alert runModal];

        return;
    } else {
        [alert setMessageText:@"Error"];
        [alert setInformativeText:@"Cannot inject payload!"];
        [alert runModal];

        return;
    }
}

@end
