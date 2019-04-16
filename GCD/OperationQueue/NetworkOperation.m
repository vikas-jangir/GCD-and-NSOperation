//
//  NetworkOperation.m
//  GCD
//
//  Created by Vikas Kumar Jangir on 12/04/19.
//  Copyright © 2019 inmobi. All rights reserved.
//

#import "NetworkOperation.h"

@interface NetworkOperation () <NSURLSessionDataDelegate>
@property (nonatomic,strong) NSURLSession* session;
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSHTTPURLResponse* httpURLResponse;
@property (nonatomic,assign,getter=isExecuting) BOOL executing;
@property (nonatomic,assign,getter=isFinished) BOOL finished;
@end

@implementation NetworkOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRequest:(NSString *)url {
    if ((self = [super init])) {
        self.URL = url;
        
    }
    return self;
    
}


- (void)start{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    self.executing = YES;
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.URL]];
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // config.timeoutIntervalForRequest = self.request.timeout;
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    [[self.session dataTaskWithRequest:urlRequest] resume];
}

- (void)cancel {
    [self.session invalidateAndCancel];
    [self finishOperation];
}

- (void)finishOperation {
    [self.session invalidateAndCancel];
    if (self.isExecuting) {
        self.executing = NO;
    }
    if (!self.isFinished) {
        self.finished = YES;
    }
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

#pragma mark NSURLSessionTaskDelegate methods

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    NSLog(@"Network Test current thread %@", [NSThread currentThread]);
    NSLog(@"willPerformHTTPRedirection");
    completionHandler(request);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    NSLog(@"Network Test current thread %@", [NSThread currentThread]);
    NSLog(@"didReceiveResponse");
    completionHandler(NSURLSessionResponseAllow);
    self.httpURLResponse = (NSHTTPURLResponse*)response;
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"Network Test current thread %@", [NSThread currentThread]);
    if (!self.receivedData) {
        self.receivedData = [[NSMutableData alloc] init];
    }
    NSLog(@"didReceiveData");
    [self.receivedData appendData:data];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"Network Test current thread %@", [NSThread currentThread]);
    NSLog(@"didCompleteWithError");
    [self finishOperation];
}

@end
