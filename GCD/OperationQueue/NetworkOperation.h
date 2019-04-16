//
//  NetworkOperation.h
//  GCD
//
//  Created by Vikas Kumar Jangir on 12/04/19.
//  Copyright © 2019 inmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkOperation : NSOperation
@property (nonatomic,strong) NSString *URL;


- (instancetype)initWithRequest:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
