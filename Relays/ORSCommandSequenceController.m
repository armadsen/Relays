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
        
        NSDictionary *bindingOptions = @{NSContinuouslyUpdatesValueBindingOption : @(YES)};
        [column bind:@"value"
            toObject:self.commandsController
         withKeyPath:[NSString stringWithFormat:@"arrangedObjects.%@", key]
             options:bindingOptions];
        [self.tableView addTableColumn:column];
    }
}

@end
