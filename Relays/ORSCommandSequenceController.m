//
//  ORSCommandSequenceController.m
//  Relays
//
//  Created by Andrew Madsen on 9/30/12.
//  Copyright (c) 2012 Open Reel Software. All rights reserved.
//

#import "ORSCommandSequenceController.h"
#import "ORSRelayControlCommand.h"

@implementation ORSCommandSequenceController

- (void)awakeFromNib
{
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
		
		[self.commandsController setContent:commands];
	}];
}

@end
