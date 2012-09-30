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
	NSUInteger relayNumber = [sender tag] + 1;
	
    ORSRelayControlPacket *packet = [[ORSRelayControlPacket alloc] init];
	packet.targetAddress = 42676;
	packet.sourceAddress = 43641;
	if (relayNumber > 0 && relayNumber <= 16)
	{
	ORSRelayCommand relayCommand = [sender state] == NSOnState ? ORSRelayCommandOn : ORSRelayCommandOff; // State here is *after* click is processed
	[packet setCommand:relayCommand forRelayNumber:[sender tag]+1];
	}
	else if (relayNumber == 17)
	{
		// All on
		[packet setCommandForAllRelays:ORSRelayCommandOn];
	}
	else if (relayNumber == 18)
	{
		// All off
		[packet setCommandForAllRelays:ORSRelayCommandOff];
	}

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
