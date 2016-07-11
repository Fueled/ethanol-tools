//
//  PausableTimerTests.m
//  EthanolTools
//
//  Created by Bastien Falcou on 8/24/15.
//  Copyright © 2015 Stephane Copin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ETHPausableTimer.h"

@import EthanolUtilities;

@interface ETHPausableTimer (PrivateTests)

@property (nonatomic, strong) NSTimer *timer;

@end

@interface PausableTimerTests : XCTestCase

@end

@implementation PausableTimerTests

- (void)testTimeIntervalNotRunningWhenTimerInitializedPaused {
  XCTestExpectation *expectation = [self expectationWithDescription:@"TimeInterval Should Be Equal To Initial Time If Started Paused"];
  
  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:1.0f target:nil selector:nil userInfo:nil paused:YES];
  [NSThread sleepForTimeInterval:0.5f];
  if (timer.timeInterval == 1.0f) {
    [expectation fulfill];
  }
  
  [self waitForExpectationsWithTimeout:0.5f handler:^(NSError * _Nullable error) {
    if (error) {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
  }];
}

- (void)testInstanceIntiializerSelector {
  XCTestExpectation *expectation = [self expectationWithDescription:@"TimeInterval Should Not Be Equal To Initial Time"];
  
  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:1.0f target:nil selector:nil userInfo:nil paused:NO];
  [NSThread sleepForTimeInterval:0.5f];
  if (timer.timeInterval != 1.0f) {
    [expectation fulfill];
  }
  
  [self waitForExpectationsWithTimeout:0.5f handler:^(NSError * _Nullable error) {
    if (error) {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
  }];
}

- (void)testClassInitializerBlock {
  XCTestExpectation *expectation = [self expectationWithDescription:@"TimeInterval Should Not Be Equal To Initial Time"];
  
  ETHPausableTimer *timer = [ETHPausableTimer timerWithTimeInterval:1.0f block:nil paused:NO];
  [NSThread sleepForTimeInterval:0.5f];
  if (timer.timeInterval != 1.0f) {
    [expectation fulfill];
  }
  
  [self waitForExpectationsWithTimeout:0.5f handler:^(NSError * _Nullable error) {
    if (error) {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
  }];
}

- (void)testClassInitializerSelector {
  XCTestExpectation *expectation = [self expectationWithDescription:@"TimeInterval Should Not Be Equal To Initial Time"];
  
  ETHPausableTimer *timer = [ETHPausableTimer timerWithTimeInterval:1.0f target:nil selector:nil userInfo:nil paused:NO];
  [NSThread sleepForTimeInterval:0.5f];
  if (timer.timeInterval != 1.0f) {
    [expectation fulfill];
  }
  
  [self waitForExpectationsWithTimeout:0.5f handler:^(NSError * _Nullable error) {
    if (error) {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
  }];
}

- (void)testTimeIntervalIsTheRightNumberOfSeconds {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Timer Finished With Right Time"];
  
  NSDate *beginDate = [NSDate date];
  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:5.0f block:^(ETHPausableTimer *timer) {
    NSTimeInterval differenceSeconds = [[NSDate date] timeIntervalSinceDate:beginDate];
    if (ETH_COMPARE_WITH_DELTA(differenceSeconds, 5.0, 0.25)) {
      [expectation fulfill];
    }
  } paused:YES];
  [timer resume];
  
  [self waitForExpectationsWithTimeout:6.0f handler:^(NSError * _Nullable error) {
    if (error) {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
  }];
}


- (void)testTimerNotRunningWhenPaused {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Timer Is Not Running When Paused"];

  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:5.0f block:nil paused:NO];
  
  [NSThread sleepForTimeInterval:2.0f];
  [timer pause];
  
  [NSThread sleepForTimeInterval:1.0f];
  if (ETH_COMPARE_WITH_DELTA(timer.timeInterval, 3.0, 0.25)) {
    [expectation fulfill];
  }
  
  [self waitForExpectationsWithTimeout:4.0f handler:^(NSError * _Nullable error) {
    if (error) {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
  }];
}

- (void)testPause {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Timer Time Elapsed Correct Even If Has Been Paused"];

  NSDate *beginDate = [NSDate date];
  ETHPausableTimer *timer = [[ETHPausableTimer alloc] initWithTimeInterval:5.0f block:^(ETHPausableTimer *timer) {
    NSTimeInterval differenceSeconds = [[NSDate date] timeIntervalSinceDate:beginDate];
    if (ETH_COMPARE_WITH_DELTA(differenceSeconds, 8.0, 0.25)) {
      [expectation fulfill];
    }
  } paused:NO];
  
  [NSThread sleepForTimeInterval:2.0f];
  [timer pause];
  
  [NSThread sleepForTimeInterval:3.0f];
  [timer resume];
  
  [self waitForExpectationsWithTimeout:9.0f handler:^(NSError * _Nullable error) {
    if (error) {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
  }];
}

- (void)testNegativeTimeInterval {
  ETHPausableTimer *timer = [ETHPausableTimer timerWithTimeInterval:1.0f block:nil paused:NO];
  timer.timeInterval = -1.0f;
  
  XCTAssertEqual(timer.timeInterval, 0.0f);
}

- (void)testForcePauseInBackgroundTimer {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Timer Time Elapsed When Force Pause In Background"];

  ETHPausableTimer *timer = [ETHPausableTimer timerWithTimeInterval:5.0f block:nil paused:YES];
  timer.forcePauseInBackground = YES;
  [timer resume];
  
  [NSThread sleepForTimeInterval:2.0f];
  if (timer.timeInterval <= 3.0f) {
    [expectation fulfill];
  }
  
  [self waitForExpectationsWithTimeout:4.0f handler:^(NSError * _Nullable error) {
    if (error) {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
  }];
}

- (void)testRedisableForcePauseInForegroundTimer {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Timer Time Elapsed When Force Pause Enabled / Disabled In Background"];
  
  ETHPausableTimer *timer = [ETHPausableTimer timerWithTimeInterval:5.0f block:nil paused:YES];
  timer.forcePauseInBackground = YES;
  timer.forcePauseInBackground = NO;
  [timer resume];
  
  [NSThread sleepForTimeInterval:2.0f];
  if (timer.timeInterval <= 3.0f) {
    [expectation fulfill];
  }
  
  [self waitForExpectationsWithTimeout:4.0f handler:^(NSError * _Nullable error) {
    if (error) {
      XCTFail(@"Expectation Failed with error: %@", error);
    }
  }];
}

@end
