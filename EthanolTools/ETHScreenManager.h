//
//  ETHScreenManager.h
//  Ethanol
//
//  Created by Stephane Copin on 1/12/15.
//  Copyright (c) 2015 Fueled Digital Media, LLC.
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

typedef NS_ENUM(NSInteger, ETHScreenStatus) {
  ETHScreenStatusUnknown = -1,
  ETHScreenStatusOff,
  ETHScreenStatusOn
};

extern NSString * ETHScreenDidTurnOffNotification;
extern NSString * ETHScreenDidTurnOnNotification;

@protocol ETHScreenManagerDelegate;

/**
 *  Provide an interface telling you what is the current screen status.
 *  If notification are needed, the recommended way to get them is to call [-startUpdatingScreenStatus] on
 *  [ETHScreenManager sharedManager], and then listen to the notifications ETHScreenDidTurnOffNotification and
 *  ETHScreenDidTurnOnNotification.
 *  If notification are not needed, and you only use the screen notification at a specific place in your app,
 *  then instanciatation of a new instance of ETHScreenManager is the recommended way to go.
 *  Also, keep in mind that this class will only work if the application is allowed to go in the background -
 *  either by using a background mode that allows for it to run in the background, OR by beginning a background task
 *  when the application goes into the background (This will last for up to 10 minutes)
 *  The [-wakeUpScreen] method could get us rejected by apple, because of the way it hacks iOS to wake up the screen.
 *  @note This class only use public API and should be safe to use in app-store apps.
 */
@interface ETHScreenManager : NSObject

/**
 *  The current screen status (KVO-compliant, if needed)
 */
@property (nonatomic, assign, readonly) ETHScreenStatus screenStatus;
/**
 *  The delegate of the screen manager.
 */
@property (nonatomic, weak) id<ETHScreenManagerDelegate> delegate;

/**
 *  Return a singleton instance of ETHScreenManager. It's delegate instance will always return nil and can't be set.
 *  Please use the notifications ETHScreenDidTurnOffNotification and ETHScreenDidTurnOnNotification instead.
 *
 *  @return The singleton instance of ETHScreenManager.
 */
+ (instancetype)sharedManager;

/**
 *  Init the screen manager with the known screen status when initialized.
 *
 *  @return The new screen manager
 */
- (instancetype)init;

/**
 *  Init the screen manager with the known screen status when initialized.
 *  @note This is the designated initializer.
 *
 *  @param screenStatus The known screen status.
 *
 *  @return The new screen manager
 */
- (instancetype)initWithScreenStatus:(ETHScreenStatus)screenStatus;

/**
 *  Init the screen manager with the known screen status when initialized.
 *  @note This is the designated initializer.
 *
 *  @param screenStatus The known screen status.
 *  @param delegate     The delegate.
 *
 *  @return The new screen manager
 */
- (instancetype)initWithScreenStatus:(ETHScreenStatus)screenStatus delegate:(id<ETHScreenManagerDelegate>)delegate;

/**
 *  Start updating the instance's screen status.
 */
- (void)startUpdatingScreenStatus;

/**
 *  Stop updating the instance's screen status.
 */
- (void)stopUpdatingScreenStatus;

/**
 *  Try to wake up the screen as soon as the method is called (Asynchronous)
 *  This method has no effect if the screen status is ETHScreenStatusUnknown or if it is ETHScreenStatusOn.
 */
+ (void)wakeUpScreen;

/**
 *  Wake up the screen by displaying a message that may be seem by the user on its locked screen.
 *  This method has no effect if the screen status is ETHScreenStatusUnknown or if it is ETHScreenStatusOn.
 *
 *  @param message The message that the user may or may not be able to read on its locked screen.
 */
+ (void)wakeUpScreenWithMessage:(NSString *)message;

/**
 *  Wake up the screen by displaying a message that the user will see, and that will disappear after a certain time.
 *  This method has no effect if the screen status is ETHScreenStatusUnknown or if it is ETHScreenStatusOn.
 *
 *  @param message The message that the user will see for the given time.
 *  @param timeout The timeout after which the message will disappear from the user locked screen.
 */
+ (void)wakeUpScreenWithMessage:(NSString *)message timeout:(NSTimeInterval)timeout;

@end

@protocol ETHScreenManagerDelegate <NSObject>

@optional
- (void)screenManagerDidScreenTurnOff:(ETHScreenManager *)screenManager;
- (void)screenManagerDidScreenTurnOn:(ETHScreenManager *)screenManager;

@end
