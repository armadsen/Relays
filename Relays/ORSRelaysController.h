//
//  ORSRelaysController.h
//  Relays
//
//  Created by Andrew Madsen on 9/29/12.
//  Copyright (c) 2012 Open Reel Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORSSerialPort;
@class ORSSerialPortManager;

@interface ORSRelaysController : NSObject

- (IBAction)relayButtonClicked:(id)sender;

@property (nonatomic, strong) ORSSerialPortManager *serialPortManager;
@property (nonatomic, strong) ORSSerialPort *serialPort;

// IBOutlets

@property (nonatomic, weak) IBOutlet NSButton *relay1Button;
@property (nonatomic, weak) IBOutlet NSButton *relay2Button;
@property (nonatomic, weak) IBOutlet NSButton *relay3Button;
@property (nonatomic, weak) IBOutlet NSButton *relay4Button;
@property (nonatomic, weak) IBOutlet NSButton *relay5Button;
@property (nonatomic, weak) IBOutlet NSButton *relay6Button;
@property (nonatomic, weak) IBOutlet NSButton *relay7Button;
@property (nonatomic, weak) IBOutlet NSButton *relay8Button;
@property (nonatomic, weak) IBOutlet NSButton *relay9Button;
@property (nonatomic, weak) IBOutlet NSButton *relay10Button;
@property (nonatomic, weak) IBOutlet NSButton *relay11Button;
@property (nonatomic, weak) IBOutlet NSButton *relay12Button;
@property (nonatomic, weak) IBOutlet NSButton *relay13Button;
@property (nonatomic, weak) IBOutlet NSButton *relay14Button;
@property (nonatomic, weak) IBOutlet NSButton *relay15Button;
@property (nonatomic, weak) IBOutlet NSButton *relay16Button;


@end
