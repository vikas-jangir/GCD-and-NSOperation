//
//  ThreadUtil.h
//  GCD
//
//  Created by Vikas Kumar Jangir on 16/04/19.
//  Copyright © 2019 inmobi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^MainCompletionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ThreadUtil : NSObject
+ (BOOL)isRunningOnMainThread;
+ (void)invokeOnMainThreadAsSynced:(BOOL)sync withCompletionBlock:(MainCompletionBlock)compBlock;
+ (void)invokeOnDispatchQueueAsSynced:(BOOL)sync forPriority:(dispatch_queue_priority_t)priority  withCompletionBlock:(MainCompletionBlock)compBlock;
+ (dispatch_queue_t)invokeOnDispatchQueueNamed:(NSString*)name withConcurrency:(BOOL)concurrent asSynced:(BOOL)sync withCompletionBlock:(MainCompletionBlock)compBlock;
@end

NS_ASSUME_NONNULL_END
