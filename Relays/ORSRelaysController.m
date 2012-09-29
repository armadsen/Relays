//
//  ORSRelaysController.m
//  Relays
//
//  Created by Andrew Madsen on 9/29/12.
//  Copyright (c) 2012 Open Reel Software. All rights reserved.
//

#import "ORSRelaysController.h"
#import "ORSSerialPort.h"

@implementation ORSRelaysController

- (IBAction)relayButtonClicked:(id)sender;
{
    
}

#pragma mark - Properties

@synthesize serialPort = _serialPort;
- (void)setSerialPort:(ORSSerialPort *)port
{
    if (port != _serialPort) {
        [_serialPort close];
        _serialPort = port;
        _serialPort.baudRate = @(B57600);
        [_serialPort open];
    }
}

@end
