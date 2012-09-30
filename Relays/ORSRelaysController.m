//
//  ORSRelaysController.m
//  Relays
//
//  Created by Andrew Madsen on 9/29/12.
//  Copyright (c) 2012 Open Reel Software. All rights reserved.
//

#import "ORSRelaysController.h"
#import "ORSSerialPortManager.h"
#import "ORSSerialPort.h"
#import "ORSRelayControlPacket.h"

@implementation ORSRelaysController

- (void)awakeFromNib
{
    self.serialPortManager = [ORSSerialPortManager sharedSerialPortManager];
}

- (IBAction)relayButtonClicked:(id)sender;
{
    ORSRelayControlPacket *packet = [[ORSRelayControlPacket alloc] init];
    [packet setCommand:ORSRelayCommandOn forRelayNumber:[sender tag]+1];
    
    NSData *data = [packet packetData];
    [self.serialPort sendData:data];
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
