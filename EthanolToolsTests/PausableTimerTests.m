//
//  PausableTimerTests.m
//  EthanolTools
//
//  Created by Bastien Falcou on 8/24/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ETHPausableTimer.h"

@interface ETHPausableTimer (PrivateTests)

@property (nonatomic, strong) NSTimer *timer;

@end

@interface PausableTimerTests : XCTestCase

@end

@implementation PausableTimerTests

- (void)testTimeIntervalRunningWhenTimerInitializedNotPaused {
  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:5.0f block:nil paused:NO];
  [NSThread sleepForTimeInterval:0.5f];
  
  XCTAssertNotEqual(timer.timeInterval, 5.0f);
}

- (void)testTimeIntervalNotRunningWhenTimerInitializedPaused {
  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:5.0f block:nil paused:YES];
  [NSThread sleepForTimeInterval:0.5f];
  
  XCTAssertEqual(timer.timeInterval, 5.0f);
}

- (void)testInstanceIntiializerSelector {
  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:1.0f target:nil selector:nil userInfo:nil paused:NO];
  [NSThread sleepForTimeInterval:0.5f];
  
  XCTAssertNotEqual(timer.timeInterval, 1.0f);
}

- (void)testClassInitializerBlock {
  ETHPausableTimer *timer = [ETHPausableTimer timerWithTimeInterval:1.0f block:nil paused:NO];
  [NSThread sleepForTimeInterval:0.5f];
  
  XCTAssertNotEqual(timer.timeInterval, 1.0f);}

- (void)testClassInitializerSelector {
  ETHPausableTimer *timer = [ETHPausableTimer timerWithTimeInterval:1.0f target:nil selector:nil userInfo:nil paused:NO];
  [NSThread sleepForTimeInterval:0.5f];
  
  XCTAssertNotEqual(timer.timeInterval, 1.0f);
}

- (void)testTimeIntervalIsTheRightNumberOfSeconds {
  NSDate *beginDate = [NSDate date];
  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:5.0f block:^(ETHPausableTimer *timer) {
    NSTimeInterval differenceSeconds = [[NSDate date] timeIntervalSinceDate:beginDate];
    XCTAssert(differenceSeconds > 4.9f && differenceSeconds < 5.1f);
  } paused:YES];
  [timer resume];
}

- (void)testTimerNotRunningWhenPaused {
  NSDate *beginDate = [NSDate date];
  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:5.0f block:^(ETHPausableTimer *timer) {
    NSTimeInterval differenceSeconds = [[NSDate date] timeIntervalSinceDate:beginDate];
    XCTAssert(differenceSeconds > 4.9f && differenceSeconds < 5.1f);
  } paused:NO];
  
  [NSThread sleepForTimeInterval:2.0f];
  [timer pause];
  
  [NSThread sleepForTimeInterval:1.0f];
  XCTAssert(timer.timeInterval > 2.9f && timer.timeInterval < 3.1f);
}

- (void)testPause {
  NSDate *beginDate = [NSDate date];
  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:5.0f block:^(ETHPausableTimer *timer) {
    NSTimeInterval differenceSeconds = [[NSDate date] timeIntervalSinceDate:beginDate];
    XCTAssert(differenceSeconds > 7.9f && differenceSeconds < 8.1f);
  } paused:NO];
  
  [NSThread sleepForTimeInterval:2.0f];
  [timer pause];
  
  [NSThread sleepForTimeInterval:3.0f];
  [timer resume];
}

- (void)testNegativeTimeInterval {
  ETHPausableTimer *timer = [ETHPausableTimer timerWithTimeInterval:1.0f block:nil paused:NO];
  timer.timeInterval = -1.0f;
  
  XCTAssertEqual(timer.timeInterval, 0.0f);
}

- (void)testForcePauseInBackgroundTimer {
  ETHPausableTimer *timer = [ETHPausableTimer timerWithTimeInterval:5.0f block:nil paused:YES];
  timer.forcePauseInBackground = YES;
  [timer resume];
  
  [NSThread sleepForTimeInterval:2.0f];
  XCTAssertLessThanOrEqual(timer.timeInterval, 3.0f);
}

- (void)testRedisableForcePauseInForegroundTimer {
  ETHPausableTimer *timer = [ETHPausableTimer timerWithTimeInterval:5.0f block:nil paused:YES];
  timer.forcePauseInBackground = YES;
  timer.forcePauseInBackground = NO;
  [timer resume];
  
  [NSThread sleepForTimeInterval:2.0f];
  XCTAssertLessThanOrEqual(timer.timeInterval, 3.0f);
}

@end