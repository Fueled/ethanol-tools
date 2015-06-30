//
//  ETHPausableTimer.m
//  Cheekd
//
//  Created by Stephane Copin on 10/22/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETHPausableTimer.h"
#include "ETHLogger.h"

@interface ETHPausableTimer ()

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL selector;

@property (nonatomic, copy) NSDate * startDate;
@property (nonatomic, copy) ETHPausableTimerTriggeredBlock block;

@end

@implementation ETHPausableTimer

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(ETHPausableTimerTriggeredBlock)block paused:(BOOL)paused {
  return [[self alloc] initWithTimeInterval:timeInterval block:block paused:paused];
}
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo paused:(BOOL)paused {
  return [[self alloc] initWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo paused:paused];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval block:(ETHPausableTimerTriggeredBlock)block paused:(BOOL)paused {
  self = [super init];
  if(self != nil) {
    _timeInterval = timeInterval;
    _block = block;
    
    if(!paused) {
      [self resume];
    }
  }
  return self;
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo paused:(BOOL)paused {
  self = [super init];
  if(self != nil) {
    _timeInterval = timeInterval;
    _target = target;
    _selector = selector;
    _userInfo = userInfo;
    
    if(!paused) {
      [self resume];
    }
  }
  return self;
}

- (NSTimeInterval)timeInterval {
  if(_timeInterval < 0.0f) {
    _timeInterval = 0.0f;
  }
  return _timeInterval;
}

- (void)dealloc {
  self.timer = nil;
  self.forcePauseInBackground = NO;
}

- (void)setTimer:(NSTimer *)timer {
  if(timer != _timer) {
    [_timer invalidate];
    _timer = timer;
  }
}

- (BOOL)isPaused {
  return self.timer == nil && self.startDate == nil;
}

- (void)setForcePauseInBackground:(BOOL)forcePauseInBackground {
  if(_forcePauseInBackground != forcePauseInBackground) {
    if(forcePauseInBackground) {
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(applicationDidEnterBackgroundHandler:)
                                                   name:UIApplicationDidEnterBackgroundNotification
                                                 object:nil];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(applicationWillEnterForegroundHandler:)
                                                   name:UIApplicationWillEnterForegroundNotification
                                                 object:nil];
    } else {
      [[NSNotificationCenter defaultCenter] removeObserver:self
                                                      name:UIApplicationDidEnterBackgroundNotification
                                                    object:nil];
      
      [[NSNotificationCenter defaultCenter] removeObserver:self
                                                      name:UIApplicationWillEnterForegroundNotification
                                                    object:nil];
    }
    _forcePauseInBackground = forcePauseInBackground;
  }
}

- (void)applicationDidEnterBackgroundHandler:(NSNotification *)notification {
  [self pause];
}

- (void)applicationWillEnterForegroundHandler:(NSNotification *)notification {
  [self resume];
}

- (void)pause {
  if(!self.isPaused) {
    self.timeInterval -= [[NSDate date] timeIntervalSinceDate:self.startDate];
  }
  self.startDate = nil;
  self.timer = nil;
}

- (BOOL)resume {
  if(self.isPaused && self.timeInterval > 0.0f) {
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(timerTriggered:) userInfo:self.userInfo repeats:NO];
    if(self.timer == nil) {
      return NO;
    }
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.startDate = [NSDate date];
  }
  return YES;
}

- (void)timerTriggered:(NSTimer *)timer {
  if(self.timeInterval > 0.0f) {
    if(self.block != nil) {
      self.block(self);
    } else {
      [self.target performSelectorOnMainThread:self.selector withObject:self waitUntilDone:NO];
    }
  }
  self.startDate = nil;
  self.timer = nil;
}

@end
