//
//  ORSRelayControlPacket.m
//  Relays
//
//  Created by Andrew Madsen on 9/29/12.
//  Copyright (c) 2012 Open Reel Software. All rights reserved.
//

#import "ORSRelayControlCommand.h"
#import "HexPacket.h"

@implementation ORSRelayControlCommand

- (void)setCommand:(ORSRelayCommand)command forRelayNumber:(NSUInteger)relayNumber;
{
	if (relayNumber == 0 || relayNumber > [[self relayCommands] count]) return;
    
    NSString *key = [NSString stringWithFormat:@"relay%luCommand", relayNumber];
    [self setValue:@(command) forKey:key];
}

- (ORSRelayCommand)commandForRelayNumber:(NSUInteger)relayNumber;
{
    if (relayNumber > [[self relayCommands] count]-1) return ORSRelayCommandUnchanged;
    
    NSString *key = [NSString stringWithFormat:@"relay%luCommand", relayNumber];
    return [[self valueForKey:key] unsignedIntegerValue];
}

- (void)setCommandForAllRelays:(ORSRelayCommand)command;
{
	for (NSUInteger i=1; i<=16; i++) {
		[self setCommand:command forRelayNumber:i];
	}
}

- (NSData *)packetData
{
    NSMutableData *result = [NSMutableData dataWithCapacity:28];
    
    [result appendData:[self andMask]];
    [result appendData:[self orMask]];
    
    [result appendData:[@"R" dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSMutableData *sourceAddr = [NSMutableData dataWithBytes:&(char[]){0x00} length:4];
    CvtIntToFourDigitHexStr([sourceAddr mutableBytes], self.sourceAddress);
    [result appendData:sourceAddr];
    
    [result appendData:[@"PS#" dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSMutableData *targetAddr = [NSMutableData dataWithBytes:&(char[]){0x00} length:4];
    CvtIntToFourDigitHexStr([targetAddr mutableBytes], self.targetAddress);
    [result appendData:targetAddr];
    
    [result appendData:[@"TU@$" dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSData *checksum = [self checksumForData:result];
    NSData *invertedChecksum = [self invertedChecksumForData:result];
    [result replaceBytesInRange:NSMakeRange(0, 0) withBytes:[invertedChecksum bytes] length:[checksum length]];
    [result replaceBytesInRange:NSMakeRange(0, 0) withBytes:[checksum bytes] length:[checksum length]];
    
    return result;
}

#pragma mark - Private

- (NSData *)checksumForData:(NSData *)data
{
    unsigned char checksum = 0;
    for (int i=0; i<[data length]; i++)
    {
        checksum += ((unsigned char *)[data bytes])[i];
    }
	
    NSMutableData *result = [NSMutableData dataWithBytes:&(char[]){0x00, 0x00} length:2];
    CvtByteValToTwoDigitHexStr([result mutableBytes], checksum);
    return result;
}

- (NSData *)invertedChecksumForData:(NSData *)data
{
    unsigned char checksum = 0;
    for (int i=0; i<[data length]; i++)
    {
        checksum += ((unsigned char *)[data bytes])[i];
    }
    
    checksum = 255 - checksum; // Bitwise invert
    NSMutableData *result = [NSMutableData dataWithBytes:&(char[]){0x00, 0x00} length:2];
    CvtByteValToTwoDigitHexStr([result mutableBytes], checksum);
    return result;
}

- (NSData *)andMask
{
    uint16_t mask = 0;
    NSArray *relayCommands = [self relayCommands];
    for (NSUInteger i = 0; i < [relayCommands count]; i++) {
        NSUInteger command = [relayCommands[i] unsignedIntegerValue];
        switch (command) {
            case ORSRelayCommandUnchanged:
            case ORSRelayCommandOn:
                mask |= (1 << i); // Set the corresponding bit in the mask
                break;
            case ORSRelayCommandMomentaryOn:
            case ORSRelayCommandOff:
                mask &= ~(1 << i); // Clear the corresponding bit in the mask
                break;
            default:
                break;
        }
    }
    
    NSMutableData *result = [NSMutableData dataWithBytes:&(char[]){0x00} length:4];
    CvtIntToFourDigitHexStr([result mutableBytes], mask);
    return result;
}

- (NSData *)orMask
{
    uint16_t mask = 0;
    NSArray *relayCommands = [self relayCommands];
    for (NSUInteger i = 0; i < [relayCommands count]; i++) {
        NSUInteger command = [relayCommands[i] unsignedIntegerValue];
        switch (command) {
            case ORSRelayCommandMomentaryOn:
            case ORSRelayCommandOn:
                mask |= (1 << i); // Set the corresponding bit in the mask
                break;
            case ORSRelayCommandUnchanged:
            case ORSRelayCommandOff:
                mask &= ~(1 << i); // Clear the corresponding bit in the mask
                break;
            default:
                break;
        }
    }
    
    NSMutableData *result = [NSMutableData dataWithBytes:&(char[]){0x00} length:4];
    CvtIntToFourDigitHexStr([result mutableBytes], mask);
    return result;
}

- (NSArray *)relayCommands
{
    return @[@(self.relay1Command), @(self.relay2Command), @(self.relay3Command), @(self.relay4Command), @(self.relay5Command), @(self.relay6Command), @(self.relay7Command), @(self.relay8Command), @(self.relay9Command), @(self.relay10Command), @(self.relay11Command), @(self.relay12Command), @(self.relay13Command), @(self.relay14Command), @(self.relay15Command), @(self.relay16Command)];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.sourceAddress forKey:[NSString stringWithFormat:@"%@_sourceAddress", NSStringFromClass([self class])]];
    [aCoder encodeInt:self.targetAddress forKey:[NSString stringWithFormat:@"%@_targetAddress", NSStringFromClass([self class])]];
    for (NSUInteger i=1; i<=16; i++) {
        NSString *key = [NSString stringWithFormat:@"%@_relay%luCommand", NSStringFromClass([self class]), i];
		[aCoder encodeObject:@([self commandForRelayNumber:i]) forKey:key];
	}
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self)
    {
        self.sourceAddress = [aDecoder decodeIntForKey:[NSString stringWithFormat:@"%@_sourceAddress", NSStringFromClass([self class])]];
        self.targetAddress = [aDecoder decodeIntForKey:[NSString stringWithFormat:@"%@_targetAddress", NSStringFromClass([self class])]];
        for (NSUInteger i=1; i<=16; i++) {
            NSString *key = [NSString stringWithFormat:@"%@_relay%luCommand", NSStringFromClass([self class]), i];
            [self setCommand:[[aDecoder decodeObjectForKey:key] unsignedIntegerValue] forRelayNumber:i];
        }
    }
    return self;
}

#pragma mark -

- (void)setNilValueForKey:(NSString *)key
{
	if ([key rangeOfString:@"Command"].location != NSNotFound)
	{
		[self setValue:@(ORSRelayCommandUnchanged) forKey:key];
		return;
	}
	
	[super setNilValueForKey:key];
}

@end
