//
//  ORSCommandSequenceController.h
//  Relays
//
//  Created by Andrew Madsen on 9/30/12.
//  Copyright (c) 2012 Open Reel Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORSCommandSequenceController : NSObject

@property (nonatomic, weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) IBOutlet NSArrayController *commandsController;

@end
