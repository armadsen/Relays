//
//  ORSRelayControlPacket.h
//  Relays
//
//  Created by Andrew Madsen on 9/29/12.
//  Copyright (c) 2012 Open Reel Software. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    ORSRelayCommandUnchanged,
    ORSRelayCommandOff,
    ORSRelayCommandOn,
    ORSRelayCommandMomentaryOn,
}; typedef NSUInteger ORSRelayCommand;

@interface ORSRelayControlPacket : NSObject

@property (nonatomic) int sourceAddress;
@property (nonatomic) int targetAddress;

@property (nonatomic) ORSRelayCommand relay1Command;
@property (nonatomic) ORSRelayCommand relay2Command;
@property (nonatomic) ORSRelayCommand relay3Command;
@property (nonatomic) ORSRelayCommand relay4Command;
@property (nonatomic) ORSRelayCommand relay5Command;
@property (nonatomic) ORSRelayCommand relay6Command;
@property (nonatomic) ORSRelayCommand relay7Command;
@property (nonatomic) ORSRelayCommand relay8Command;
@property (nonatomic) ORSRelayCommand relay9Command;
@property (nonatomic) ORSRelayCommand relay10Command;
@property (nonatomic) ORSRelayCommand relay11Command;
@property (nonatomic) ORSRelayCommand relay12Command;
@property (nonatomic) ORSRelayCommand relay13Command;
@property (nonatomic) ORSRelayCommand relay14Command;
@property (nonatomic) ORSRelayCommand relay15Command;
@property (nonatomic) ORSRelayCommand relay16Command;

@property (nonatomic, readonly) NSData *packetData;

@end
