//
//  RelapSDKRequestOperation.m
//  Relap SDK Example
//
//  Created by Igor Kamenev on 16/12/14.
//  Copyright (c) 2014 Relap.io. All rights reserved.
//

#import "RelapSDKRequestOperation.h"

typedef enum {
    
    RelapSDKRequestOperationStateReady = 1,
    RelapSDKRequestOperationStateExecuting = 2,
    RelapSDKRequestOperationStateFinished = 3,
    RelapSDKRequestOperationStateCanceled = 4,
    
} RelapSDKRequestOperationState;

@interface RelapSDKRequestOperation ()

@property (nonatomic, strong) NSOperationQueue* queue;
@property (nonatomic, strong) NSMutableData* responseData;
@property (nonatomic) RelapSDKRequestOperationState state;

@property (nonatomic, strong) NSURLConnection* connection;

@end

@implementation RelapSDKRequestOperation

-(id)initWithRequest: (NSURLRequest*) request
{
    self = [super init];
    
    if (self) {
        self.request = request;
        self.state = RelapSDKRequestOperationStateReady;
        self.queue = [[NSOperationQueue alloc] init];
        self.responseData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void) done
{
    if(self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.state = RelapSDKRequestOperationStateFinished;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

-(void)canceled {
    
    [self done];
    
    NSError* error = [NSError errorWithDomain:@"RelapSDK" code:-999 userInfo:[NSDictionary dictionaryWithObject:@"Loading operation canceled" forKey:NSLocalizedDescriptionKey]];
    
    if (self.failureBlock) {
        self.failureBlock(self, error);
    }
    
}

- (void) start
{
    if (self.state == RelapSDKRequestOperationStateCanceled
        || self.state == RelapSDKRequestOperationStateFinished
        || [self isCancelled] )
    {
        [self done];
        return;
    }
    
    if ([self isReady]) {
        
        [self willChangeValueForKey:@"isExecuting"];
        self.state = RelapSDKRequestOperationStateExecuting;
        [self didChangeValueForKey:@"isExecuting"];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request
                                                          delegate:self
                                                  startImmediately:NO];
        [self.connection setDelegateQueue:self.queue];
        [self.connection start];
    }
}

-(BOOL)isConcurrent
{
    return YES;
}

-(BOOL)isFinished
{
    return (self.state == RelapSDKRequestOperationStateFinished);
}

-(BOOL)isExecuting
{
    return (self.state == RelapSDKRequestOperationStateExecuting);
}

- (void) didDownloadComplete
{
    if (self.isCancelled)
        return;
    
    if (self.successBlock) {
        self.successBlock(self, self.responseData);
    }
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    self.state = RelapSDKRequestOperationStateFinished;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    
    if([self isCancelled]) {
        [self canceled];
        return;
    }
    
    if (response.statusCode >= 400) {

        [self done];

        if (self.failureBlock) {

            NSString* responseCode = [NSString stringWithFormat:@"Response code is: %ld", response.statusCode];
            
            NSError* error = [NSError errorWithDomain:@"RelapSDK" code:1 userInfo:@{NSLocalizedDescriptionKey: responseCode}];
            self.failureBlock(self, error);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if([self isCancelled]) {
        [self canceled];
        return;
    }
    
    @try {
        [_responseData appendData:data];
    }
    @catch (NSException *exception) {
        
        if([self isCancelled]) {
            [self canceled];
            return;
        }
        else {
            [self done];
        }
        
        if (self.failureBlock) {
            self.failureBlock(self, nil);
        }
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if([self isCancelled]) {
        [self canceled];
        return;
    }
    
    [self didDownloadComplete];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if([self isCancelled]) {
        [self canceled];
        return;
    }
    else {
        [self done];
    }
    
    if (self.failureBlock) {
        self.failureBlock(self, error);
    }
}

@end
