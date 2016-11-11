//
//  ETHCocoaLumberjackLogger.m
//  Ethanol
//
//  Created by Stephane Copin on 12/17/14.
//  Copyright (c) 2014 Fueled Digital Media, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

@import CocoaLumberjack;

#import "ETHCocoaLumberjackLogger.h"
#import "ETHCocoaLumberjackFormatter.h"
#import "ETHInjector.h"

@implementation ETHCocoaLumberjackLogger
@synthesize logLevel = _logLevel;

+ (void)load {
  [DDASLLogger sharedInstance].logFormatter = [[ETHCocoaLumberjackFormatter alloc] init];
  [DDTTYLogger sharedInstance].logFormatter = [DDASLLogger sharedInstance].logFormatter;
}

- (void)log:(ETHLogFlag)flag file:(NSString *)file function:(NSString *)function line:(int)line format:(NSString *)format, ... {
  va_list args;
  va_start(args, format);
  
  [self log:flag file:file function:function line:line format:format arguments:args];
  
  va_end(args);
}

- (void)log:(ETHLogFlag)flag file:(NSString *)file function:(NSString *)function line:(int)line format:(NSString *)format arguments:(va_list)arguments {
  [DDLog log:NO level:(int)self.logLevel flag:(DDLogFlag)flag context:INT_MAX file:[file UTF8String] function:[function UTF8String] line:line tag:nil format:format args:arguments];
}

@end
