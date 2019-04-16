//
//  GDCSerialQueue.m
//  GCD
//
//  Created by Vikas Kumar Jangir on 01/04/19.
//  Copyright © 2019 inmobi. All rights reserved.
//

#import "GDCSerialQueue.h"
#import "ThreadUtil.h"




@interface GDCSerialQueue ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSMutableArray *myArray;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) pthread_rwlock_t *lock;
@end

@implementation GDCSerialQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.serialQueue = dispatch_queue_create("GCD_vikas_serialQueue", NULL);
    }
    return self;
}


-(void)runSerialQueue_Sync_On_MainThread {
    [ThreadUtil invokeOnMainThreadAsSynced:YES withCompletionBlock:^{
        dispatch_sync(self.serialQueue, ^{
            NSLog(@"Test %@", [NSThread currentThread]);
        });
    }];
}

-(void)runSerialQueue_aSync_On_MainThread {
    
    [ThreadUtil invokeOnMainThreadAsSynced:NO withCompletionBlock:^{
        dispatch_async(self.serialQueue, ^{
            NSLog(@"Test %@", [NSThread currentThread]);
        });
    }];
}

-(void)runSerialQueue_Sync_On_BGThread {
    [ThreadUtil invokeOnDispatchQueueAsSynced:YES forPriority:DISPATCH_QUEUE_PRIORITY_DEFAULT withCompletionBlock:^{
        dispatch_sync(self.serialQueue, ^{
            NSLog(@"Test %@", [NSThread currentThread]);
        });
    }];
}

-(void)runSerialQueue_aSync_On_BGThread {
    [ThreadUtil invokeOnDispatchQueueAsSynced:NO forPriority:DISPATCH_QUEUE_PRIORITY_DEFAULT withCompletionBlock:^{
        dispatch_async(self.serialQueue, ^{
            NSLog(@"Test %@", [NSThread currentThread]);
        });
    }];
}

-(void)ExecuteCode {
    [self runSerialQueue_Sync_On_MainThread];
    [self runSerialQueue_aSync_On_MainThread];
    [self runSerialQueue_Sync_On_BGThread];
    [self runSerialQueue_aSync_On_BGThread];
}


- (void)addingArray {
    for (int i=0 ; i<10; i++) {
        @synchronized (self) {
            [self.myArray addObject:[NSNumber numberWithInteger:i]];
            NSLog(@"addingArray log :- %@", [NSNumber numberWithInteger:i]);
        }
    }
    NSLog(@"addingArray Completed");
}

- (void)removingArray {
    for (int i=0 ; i<10000; i++) {
        [self.myArray removeObjectAtIndex:(int)[NSNumber numberWithInteger:i]];
        NSLog(@"removingArray log :- %@", [NSNumber numberWithInteger:i]);
    }
    NSLog(@"removingArray Completed");
}






+ (uint64_t)timeSince1970InMillisecondsFromDate:(NSDate *)date {
    return (uint64_t)( (double) ([date timeIntervalSince1970] * 1000LL));
}
+ (uint64_t)timeSince1970InMillisecondsFromNow {
    return [self timeSince1970InMillisecondsFromDate:[NSDate date]];
}

@end
