//
//  ETHPausableTimer.h
//  Cheekd
//
//  Created by Stephane Copin on 10/22/14.
//  Copyright (c) 2014 Fueled. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ETHPausableTimer;

typedef void (^ ETHPausableTimerTriggeredBlock)(ETHPausableTimer * timer);

@interface ETHPausableTimer : NSObject

@property (nonatomic, assign) BOOL forcePauseInBackground;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign, readonly, getter=isPaused) BOOL paused;

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(ETHPausableTimerTriggeredBlock)block paused:(BOOL)paused;
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo paused:(BOOL)paused;

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval block:(ETHPausableTimerTriggeredBlock)block paused:(BOOL)paused;
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo paused:(BOOL)paused;

- (void)pause;
- (BOOL)resume;

@end
