//
//  ETHLogger.h
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

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, ETHLogFlag) {
  ETHLogFlagFatal   = (1 << 0),
  ETHLogFlagError   = (1 << 1),
  ETHLogFlagWarning = (1 << 2),
  ETHLogFlagInfo    = (1 << 3),
  ETHLogFlagDebug   = (1 << 4),
  ETHLogFlagVerbose = (1 << 5),
  ETHLogFlagTrace   = (1 << 6),
};

typedef NS_OPTIONS(NSUInteger, ETHLogLevel) {
  ETHLogLevelOff     =  0,
  ETHLogLevelFatal   =  ETHLogFlagFatal,
  ETHLogLevelError   = (ETHLogFlagError   | ETHLogLevelFatal),
  ETHLogLevelWarning = (ETHLogFlagWarning | ETHLogLevelError),
  ETHLogLevelInfo    = (ETHLogFlagInfo    | ETHLogLevelWarning),
  ETHLogLevelDebug   = (ETHLogFlagDebug   | ETHLogLevelInfo),
  ETHLogLevelVerbose = (ETHLogFlagVerbose | ETHLogLevelDebug),
  ETHLogLevelTrace   = (ETHLogFlagTrace   | ETHLogLevelVerbose),
  ETHLogLevelAll     = NSUIntegerMax,
};

/**
 *  This provides an interface (To be registered wth ETHInjector) that can be used as a way to implement any kind of
 *  logging framework in a generic manner.
 *  Ethanol provides for now only one logger, implemented via CocoaLumberjack, called CocoaLumberjackLogging.
 *  You should register in the injector the class that is going to be used for logging, via:
 *  (ObjC)  [[ETHInjector defaultInjector] bindClass:[<Logger classname> class] toProtocol:@protocol(ETHLogger)];
 *  (Swift) ETHInjector.defaultInjector().bindClass(<Logger classname>.self, toProtocol: ETHLogger.self)
 *  You can also chose to completely disable Ethanol's logging system (In objective-c) by defining the macro
 *  ETHANOL_DISABLE_LOGGING in the Build Settings of your app. This ensure that every call to the ETHLog<Level> macros
 *  will be converted into noop.
 *  @note This means that, if the macro ETHANOL_DISABLE_LOGGING is enabled, none of its arguments will be evaluated.
 *  Never include method call, assignment and such in the logging macros!
 */
@protocol ETHLogger <NSObject>

@property (nonatomic, assign) ETHLogLevel logLevel;

- (void)log:(ETHLogFlag)flag file:(NSString *)file function:(NSString *)function line:(int)line format:(NSString *)format, ... NS_FORMAT_FUNCTION(5,6);
- (void)log:(ETHLogFlag)flag file:(NSString *)file function:(NSString *)function line:(int)line format:(NSString *)format arguments:(va_list)arguments;

@end

#undef _ETHLog

#undef _ETHTryLog

#undef ETHLogTrace
#undef ETHLogVerbose
#undef ETHLogDebug
#undef ETHLogInfo
#undef ETHLogWarning
#undef ETHLogError
#undef ETHLogFatal

#define _ETHLog(flag, formatString, ...) \
  do { \
    id<ETHLogger> logger = [[ETHInjector defaultInjector] protocolInstanceForProtocol:@protocol(ETHLogger)]; \
    if((logger.logLevel & (flag)) == (flag)) { \
      [logger log:(flag) file:[NSString stringWithUTF8String:__FILE__] function:NSStringFromSelector(_cmd) line:__LINE__ format:(formatString), ## __VA_ARGS__]; \
    } \
  } while(0)

#if !defined(ETHANOL_DISABLE_LOGGING)
#define _ETHTryLog(flag, formatString, ...) _ETHLog(flag, formatString, ## __VA_ARGS__)
#else
#define _ETHTryLog(flag, formatString, ...) do { } while(0)
#endif

#define ETHLogTrace(format, ...)   _ETHTryLog(ETHLogFlagTrace,   format, ## __VA_ARGS__)
#define ETHLogVerbose(format, ...) _ETHTryLog(ETHLogFlagVerbose, format, ## __VA_ARGS__)
#define ETHLogDebug(format, ...)   _ETHTryLog(ETHLogFlagDebug,   format, ## __VA_ARGS__)
#define ETHLogInfo(format, ...)    _ETHTryLog(ETHLogFlagInfo,    format, ## __VA_ARGS__)
#define ETHLogWarning(format, ...) _ETHTryLog(ETHLogFlagWarning, format, ## __VA_ARGS__)
#define ETHLogError(format, ...)   _ETHTryLog(ETHLogFlagError,   format, ## __VA_ARGS__)
#define ETHLogFatal(format, ...)   _ETHTryLog(ETHLogFlagFatal,   format, ## __VA_ARGS__)
