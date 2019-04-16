//
//  ThreadUtil.m
//  GCD
//
//  Created by Vikas Kumar Jangir on 16/04/19.
//  Copyright © 2019 inmobi. All rights reserved.
//

#import "ThreadUtil.h"




@implementation ThreadUtil

+ (BOOL)isRunningOnMainThread {
    return [[NSThread currentThread] isMainThread];
}

+ (void)invokeOnMainThreadAsSynced:(BOOL)sync withCompletionBlock:(MainCompletionBlock)compBlock {
    if([ThreadUtil isRunningOnMainThread]) {
        compBlock();
    } else {
        if(sync) {
            dispatch_sync(dispatch_get_main_queue(), compBlock);
        } else {
            dispatch_async(dispatch_get_main_queue(), compBlock);
        }
    }
}

+ (void)invokeOnDispatchQueueAsSynced:(BOOL)sync forPriority:(dispatch_queue_priority_t)priority withCompletionBlock:(MainCompletionBlock)compBlock {
    if(sync) {
        dispatch_sync(dispatch_get_global_queue(priority, 0), compBlock);
    } else {
        dispatch_async(dispatch_get_global_queue(priority, 0), compBlock);
    }
}

+ (dispatch_queue_t)invokeOnDispatchQueueNamed:(NSString*)name withConcurrency:(BOOL)concurrent asSynced:(BOOL)sync withCompletionBlock:(MainCompletionBlock)compBlock {
    dispatch_queue_t queue = dispatch_queue_create([name UTF8String], concurrent ? DISPATCH_QUEUE_CONCURRENT : DISPATCH_QUEUE_SERIAL);
    if(sync) {
        dispatch_sync(queue, compBlock);
    } else {
        dispatch_async(queue, compBlock);
    }
    return queue;
}


@end
