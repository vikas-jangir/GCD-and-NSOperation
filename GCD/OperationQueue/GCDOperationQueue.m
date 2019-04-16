//
//  GCDOperation.m
//  GCD
//
//  Created by Vikas Kumar Jangir on 09/04/19.
//  Copyright © 2019 inmobi. All rights reserved.
//

#import "GCDOperationQueue.h"
#import "NetworkOperation.h"


@interface GCDOperationQueue()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic,strong)NetworkOperation* operation;
@end


@implementation GCDOperationQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 2;
    }
    return self;
}

-(void)operationQueueExecute {
    for (int i=0; i<5; i++) {
        self.operation = [[NetworkOperation alloc] initWithRequest:@"https://i.l.inmobicdn.net/adtools/videoads/prod/1701d05de0294e57be0bb1e009e34566/videos/59aec942-adc0-44ec-81ba-859ef45f6bff/video.720p.mp4"];
        NSLog(@"count = %d",i);
        self.operation.queuePriority = NSOperationQueuePriorityVeryHigh;
        [self.operationQueue addOperation:self.operation];
    }
}

-(void)operationQueueExecuteWithBlockOperation {
    for (int i=0; i<5; i++) {
        [self.operationQueue addOperationWithBlock:^{
            NSLog(@"operationQueueExecuteWithBlockOperation executed");
        }];
    }
}

-(void)operationQueueExecuteWithMainBlockOperation {
    for (int i=0; i<5; i++) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"operationQueueExecuteWithMainBlockOperation executed");
        }];
    }
}


@end
