//
//  RelapSDKRequestOperation.h
//  Relap SDK Example
//
//  Created by Igor Kamenev on 16/12/14.
//  Copyright (c) 2014 Relap.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RelapSDKRequestOperation;

typedef void (^RelapSDKRequestSuccessBlock)(RelapSDKRequestOperation *operation, id responseObject);
typedef void (^RelapSDKRequestFailureBlock)(RelapSDKRequestOperation *operation, NSError* error);

@interface RelapSDKRequestOperation : NSOperation

-(id)initWithRequest: (NSURLRequest*) request;

@property (nonatomic, strong) NSURLRequest* request;

@property (nonatomic, strong) RelapSDKRequestSuccessBlock successBlock;
@property (nonatomic, strong) RelapSDKRequestFailureBlock failureBlock;

@end
