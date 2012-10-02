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
#import "ORSRelayControlCommand.h"

@interface ORSRelaysController ()

@property (nonatomic, readwrite, getter = isPlayingBackCommands) BOOL playingBackCommands;
@property (nonatomic, strong) NSMutableArray *commandsQueue;
@property (nonatomic, strong) NSTimer *commandPlaybackTimer;
@property (nonatomic, strong) NSDate *playbackStartDate;

@end

@implementation ORSRelaysController

- (void)awakeFromNib
{
    self.serialPortManager = [ORSSerialPortManager sharedSerialPortManager];
	
	// Set up commands table
	for (NSUInteger i=1; i<=16; i++) {
        NSString *key = [NSString stringWithFormat:@"relay%luCommand", i];
        NSString *title = [NSString stringWithFormat:@"Relay %lu", i];
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:title];
        [[column headerCell] setTitle:title];
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
		[numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numFormatter setMinimum:@(0)];
		[numFormatter setMaximum:@(3)];
		[[column dataCell] setFormatter:numFormatter];
		
		
        NSDictionary *bindingOptions = @{NSContinuouslyUpdatesValueBindingOption : @(YES)};
        [column bind:@"value"
            toObject:self.commandsController
         withKeyPath:[NSString stringWithFormat:@"arrangedObjects.%@", key]
             options:bindingOptions];
        [self.tableView addTableColumn:column];
    }
}

#pragma mark - Actions

- (IBAction)relayButtonClicked:(id)sender;
{
	NSUInteger relayNumber = [sender tag] + 1;
	
	BOOL shouldBeMomentary = (relayNumber >= 1 && relayNumber <= 6) || relayNumber == 9 || relayNumber == 13;
	
    ORSRelayControlCommand *packet = [[ORSRelayControlCommand alloc] init];
	packet.targetAddress = TARGET_ADDRESS;
	packet.sourceAddress = TARGET_ADDRESS;
	if (relayNumber > 0 && relayNumber <= 16)
	{
		ORSRelayCommand relayCommand;
			relayCommand = shouldBeMomentary ? ORSRelayCommandMomentaryOn : (([sender state] == NSOnState ? ORSRelayCommandOn : ORSRelayCommandOff)); // State here is *after* click is processed
		[packet setCommand:relayCommand forRelayNumber:[sender tag]+1];
	}
	else if (relayNumber == 17)
	{
		// All on
		[packet setCommandForAllRelays:ORSRelayCommandOn];
        for (NSUInteger i=1; i<=16; i++) {
            NSString *key = [NSString stringWithFormat:@"relay%luButton", i];
            NSButton *button = [self valueForKey:key];
            button.state = NSOnState;
        }
	}
	else if (relayNumber == 18)
	{
		// All off
		[packet setCommandForAllRelays:ORSRelayCommandOff];
        for (NSUInteger i=1; i<=16; i++) {
            NSString *key = [NSString stringWithFormat:@"relay%luButton", i];
            NSButton *button = [self valueForKey:key];
            button.state = NSOffState;
        }
	}
	
    NSData *data = [packet packetData];
    [self.serialPort sendData:data];
}

- (IBAction)saveCommands:(id)sender;
{
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	savePanel.allowedFileTypes = @[@"commands"];
	[savePanel beginWithCompletionHandler:^(NSInteger result) {
		if (result != NSFileHandlingPanelOKButton) return;
		
		NSArray *commands = [self.commandsController arrangedObjects];
		if (![NSKeyedArchiver archiveRootObject:commands toFile:[[savePanel URL] path]])
		{
			NSLog(@"Unable to write commands to %@", [savePanel URL]);
		}
	}];
}

- (IBAction)loadCommands:(id)sender;
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	openPanel.allowedFileTypes = @[@"commands"];
	[openPanel beginWithCompletionHandler:^(NSInteger result) {
		if (result != NSFileHandlingPanelOKButton) return;
		
		NSArray *commands = [NSKeyedUnarchiver unarchiveObjectWithFile:[[openPanel URL] path]];
		if (!commands) return;
		
		[self.commandsController setContent:[commands mutableCopy]];
	}];
}

- (IBAction)playCommands:(id)sender
{
	if (self.isPlayingBackCommands) return;
	
	self.commandsQueue = [[self.commandsController arrangedObjects] mutableCopy];
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
	[self.commandsQueue sortUsingDescriptors:@[sortDescriptor]];
	self.playbackStartDate = [NSDate date];
	self.commandPlaybackTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playNextCommands:) userInfo:nil repeats:YES];
	self.playingBackCommands = YES;
}

-(IBAction)stopPlayingCommands:(id)sender
{
	if (!self.isPlayingBackCommands) return;
	
	[self finishCommandPlayback];
	
	ORSRelayControlCommand *allOffCommand = [[ORSRelayControlCommand alloc] init];
	allOffCommand.targetAddress = TARGET_ADDRESS;
	allOffCommand.sourceAddress = SOURCE_ADDRESS;
	[allOffCommand setCommandForAllRelays:ORSRelayCommandOff];
	[self.serialPort sendData:[allOffCommand packetData]];
}

#pragma mark - Command Playback

- (void)playNextCommands:(NSTimer *)timer
{
	NSMutableArray *commandsToPlay = [NSMutableArray array];
	NSTimeInterval timeSinceStart = [[NSDate date] timeIntervalSinceDate:self.playbackStartDate];
	
	NSLog(@"%s %f", __PRETTY_FUNCTION__, timeSinceStart);
	
	for (ORSRelayControlCommand *command in self.commandsQueue)
	{
		if (command.timestamp > timeSinceStart) break;
		command.sourceAddress = SOURCE_ADDRESS;
		command.targetAddress = TARGET_ADDRESS;
		[commandsToPlay addObject:command];
	}
	
	if ([commandsToPlay count] == 0) return;
	
	[self.commandsQueue removeObjectsInArray:commandsToPlay];
	
	for (ORSRelayControlCommand *command in commandsToPlay)
	{
		[self.serialPort sendData:[command packetData]];
	}
	
	if ([self.commandsQueue count] == 0)
	{
		[self finishCommandPlayback];
	}
}

- (void)finishCommandPlayback
{
	self.playbackStartDate = nil;
	[self.commandPlaybackTimer invalidate];
	self.commandPlaybackTimer = nil;
	self.commandsQueue = nil;
	self.playingBackCommands = NO;
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
