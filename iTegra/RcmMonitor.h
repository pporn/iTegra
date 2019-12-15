//
//  RcmMonitor.h
//  iTegra
//
//  Created by Chen Yang on 12/14/19.
//  Copyright © 2019 Chen Yang. All rights reserved.
//

#ifndef RcmMonitor_h
#define RcmMonitor_h

#import <Foundation/Foundation.h>
#import <NXBootUSBLib/NXBootUSBLib.h>

@interface RcmMonitor : NSObject <NXUSBDeviceEnumeratorDelegate>
@property(strong, nonatomic) NXUSBDeviceEnumerator* usbDeviceEnumerator;
@property(strong, nonatomic) NXUSBDevice* usbDevice;

-(void) start;

@end

#endif /* RcmMonitor_h */
