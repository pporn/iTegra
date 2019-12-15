//
//  RcmMonitor.m
//  iTegra
//
//  Created by Chen Yang on 12/14/19.
//  Copyright © 2019 Chen Yang. All rights reserved.
//

#import "RcmMonitor.h"
#import <AppKit/AppKit.h>

@implementation RcmMonitor

- (void) monitor {
    [self start];
}

- (void) start {
    self.usbDeviceEnumerator = [[NXUSBDeviceEnumerator alloc] init];
    self.usbDeviceEnumerator.delegate = self;
    [self.usbDeviceEnumerator addFilterForVendorID:kTegraNintendoSwitchVendorID productID:kTegraNintendoSwitchProductID];
    [self.usbDeviceEnumerator start];
}

- (void)usbDeviceEnumerator:(NXUSBDeviceEnumerator *)deviceEnum deviceConnected:(NXUSBDevice *)device {
    self.usbDeviceEnumerator = deviceEnum;
    self.usbDevice = device;
    NSLog(@"Device connected!");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceConnected" object:nil];
}

- (void)usbDeviceEnumerator:(NXUSBDeviceEnumerator *)deviceEnum deviceDisconnected:(NXUSBDevice *)device {
    self.usbDevice = nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deviceDisconnected" object:nil];
}

- (void)usbDeviceEnumerator:(NXUSBDeviceEnumerator *)deviceEnum deviceError:(NSString *)err {
    
    self.usbDeviceEnumerator = nil;
}

@end
