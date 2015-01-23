//
//  RelapSDKExampleImageLoadingOperationQueue.m
//  RelapSDK
//
//  Created by Igor Kamenev on 22/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleImageLoadingOperationQueue.h"

@implementation RelapSDKExampleImageLoadingOperationQueue

+(NSOperationQueue*)sharedQueue
{
    static NSOperationQueue* _sharedQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedQueue = [NSOperationQueue new];
        _sharedQueue.maxConcurrentOperationCount = 4;
    });
    
    return _sharedQueue;
}

@end
