//
//  ETHCocoaLumberjackFormatter.m
//  EthanolTools
//
//  Created by Stephane Copin on 11/7/16.
//  Copyright © 2016 Stephane Copin. All rights reserved.
//

#import "ETHCocoaLumberjackFormatter.h"
#import "ETHLogger.h"

@interface ETHCocoaLumberjackFormatter ()

@property (nonatomic, strong, readonly) NSDateFormatter * dateFormatter;

@end

@implementation ETHCocoaLumberjackFormatter
@synthesize dateFormatter = _dateFormatter;

- (instancetype)init {
	self = [super init];
	if (self != nil) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		_dateFormatter.dateFormat = @"YYYY-MM-dd' 'HH-mm-ss'.'SSS";
	}
	return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
	NSMutableString * flagString = [[NSMutableString alloc] init];
#define FLAG_EMOTICON(flagName, emoticon) \
	if (!!(logMessage.flag & (int)ETHLogFlag ## flagName)) { \
		[flagString appendString:(emoticon)]; \
	}
	FLAG_EMOTICON(Trace, @"⚫️")
	FLAG_EMOTICON(Verbose, @"🔘")
	FLAG_EMOTICON(Debug, @"⚪️")
	FLAG_EMOTICON(Info, @"🔵")
	FLAG_EMOTICON(Warning, @"⚠️")
	FLAG_EMOTICON(Error, @"❌")
	FLAG_EMOTICON(Fatal, @"☢️")
	
	return [NSString stringWithFormat:@"%@ %@ %@: %@",
					flagString,
					[self.dateFormatter stringFromDate:logMessage.timestamp],
					flagString,
					logMessage.message];
}

@end
