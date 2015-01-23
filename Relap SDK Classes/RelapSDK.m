//
//  RelapSDK.m
//  Relap SDK
//
//  Created by Igor Kamenev on 16/12/14.
//  Copyright (c) 2014 Relap.io. All rights reserved.
//

#import "RelapSDK.h"

static NSString* const kRelapAPIURL = @"http://10.211.55.4/api.php";

static RelapSDK* _relapSDK;

@interface RelapSDK ()

@property (nonatomic, strong) NSString* applicationID;
@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSOperationQueue* queue;

@end

@implementation RelapSDK

+ (RelapSDK*) relapSDK
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _relapSDK = [RelapSDK new];
    });
    
    return _relapSDK;
}

-(instancetype)init
{
    if (_relapSDK)
        return _relapSDK;
    
    self = [super init];
    
    if (self) {
        self.queue = [NSOperationQueue new];
        self.queue.maxConcurrentOperationCount = 3;
    }
    
    return self;
    
}

+ (void) setupWithApplicationID: (NSString*) applicationID userID: (NSString*) userID
{
    [[self relapSDK] setupWithApplicationID:applicationID userID: userID];
}

- (void) setupWithApplicationID: (NSString*) applicationID userID: (NSString*) userID
{
    
    if (applicationID == nil) {
        NSLog(@"RelapSDK: !! WARNING !! applicationID should be not nil!");
    }
    
    if (userID == nil) {
        NSLog(@"RelapSDK: !! WARNING !! applicationID should be not nil!");
    }
    
    self.applicationID = applicationID;
    self.userID = userID;
}

+ (void) markContentSeenWithContentID: (NSString*) contentID
                                title: (NSString*) title
                                 text: (NSString*) text
                             imageUrl: (NSString*) imageUrl
                              payload: (NSDictionary*) payload
                         successBlock: (RelapSDKSuccessBlock) successBlock
                         failureBlock: (RelapSDKFailureBlock) failureBlock
{
    [[self relapSDK] markContentSeen:contentID
                               title:title
                                text:text
                            imageUrl:imageUrl
                             payload:payload
                        successBlock:successBlock
                        failureBlock:failureBlock];
}

+ (void) markContentSeen: (RelapSDKContentItem*) contentItem
{
    [self markContentSeen: contentItem successBlock:nil failureBlock:nil];
}

+ (void) markContentSeen: (RelapSDKContentItem*) contentItem
            successBlock: (RelapSDKSuccessBlock) successBlock
            failureBlock: (RelapSDKFailureBlock) failureBlock
{
    [[self relapSDK] markContentSeen:contentItem successBlock:successBlock failureBlock:failureBlock];
}

- (void) markContentSeen: (RelapSDKContentItem*) contentItem
            successBlock: (RelapSDKSuccessBlock) successBlock
            failureBlock: (RelapSDKFailureBlock) failureBlock
{

    [self markContentSeen:contentItem.contentID
                    title:contentItem.title
                     text:contentItem.text
                 imageUrl:contentItem.imageURL
                  payload:contentItem.payload
             successBlock:successBlock
             failureBlock:failureBlock];
    
}

- (void) markContentSeen: (NSString*) contentID
                   title: (NSString*) title
                    text: (NSString*) text
                imageUrl: (NSString*) imageUrl
                 payload: (NSDictionary*) payload
            successBlock: (RelapSDKSuccessBlock) successBlock
            failureBlock: (RelapSDKFailureBlock) failureBlock
{
    
    if (self.applicationID == nil) {
        
        NSLog(@"RelapSDK: !!! WARNING !!! You should setup RelapSDK first! (setupWithApplicationID:userID:)");
        
        NSError* error = [NSError errorWithDomain:@"RelapSDK" code:6 userInfo:@{NSLocalizedDescriptionKey: @"You should setup relapSDK first."}];
        
        if (failureBlock) {
            failureBlock(error);
        }
        return;
    }
    
    if (self.userID == nil) {
        
        NSLog(@"RelapSDK: !!! WARNING !!! You should setup RelapSDK first! (setupWithApplicationID:userID:)");
        
        NSError* error = [NSError errorWithDomain:@"RelapSDK" code:6 userInfo:@{NSLocalizedDescriptionKey: @"You should setup relapSDK first."}];
        
        if (failureBlock) {
            failureBlock(error);
        }
        return;
    }
    
    NSString* payloadJSONString;
    
    if (payload) {
        
        NSError* error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error && failureBlock) {
            failureBlock(error);
            return;
        }

        payloadJSONString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableDictionary* packet = [NSMutableDictionary new];
    packet[@"method"] = @"makeContentSeen";
    packet[@"applicationID"] = self.applicationID;
    packet[@"userID"] = self.userID;
    packet[@"contentID"] = contentID;

    if (title)
        packet[@"title"] = title;

    if (text)
        packet[@"text"] = text;
    
    if (imageUrl)
        packet[@"imageUrl"] = imageUrl;
    
    if (payloadJSONString) {
        packet[@"payload"] = payloadJSONString;
    }

    [self sendPacket:packet successBlock:^(id response) {
        NSLog(@"%@", response);
        NSString* str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];

        NSLog(@"%@", str);
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

+ (void) getContentRelativeToContentID: (NSString*) contentID
                          successBlock: (RelapSDKSuccessContentBlock) successBlock
                          failureBlock: (RelapSDKFailureBlock) failureBlock
{
    [[self relapSDK] getContentRelativeForContentID:contentID
                                       successBlock:successBlock
                                       failureBlock:failureBlock];
}

- (void) getContentRelativeForContentID: (NSString*) contentID
                           successBlock: (RelapSDKSuccessContentBlock) successBlock
                           failureBlock: (RelapSDKFailureBlock) failureBlock
{

    NSMutableDictionary* packet = [NSMutableDictionary new];
    packet[@"method"] = @"getRelativeContent";
    packet[@"applicationID"] = self.applicationID;
    packet[@"userID"] = self.userID;
    packet[@"contentID"] = contentID;
    
    [self sendPacket:packet successBlock:^(id response) {

        id object = [NSJSONSerialization
                     JSONObjectWithData:response
                     options:0
                     error:nil];
        
        NSMutableArray* items = [NSMutableArray new];
        
        for (NSDictionary* dict in object[@"response"]) {
            
            RelapSDKContentItem* item = [[RelapSDKContentItem alloc] initWithDict:dict];
            if (item) {
                [items addObject:item];
            }
        }
        
        if (successBlock) {
            successBlock(items);
        }
        
    } failureBlock:^(NSError *error) {

        if (failureBlock) {
            failureBlock(error);
        }
    }];
}


+ (void) getRelativeContentViewForContentItem: (RelapSDKContentItem*) contentItem
                                    viewStyle: (RelapSDKRelativeContentViewStyle) style
                                 successBlock: (RelapSDKSuccessContentViewBlock) successBlock
                                 failureBlock: (RelapSDKFailureBlock) failureBlock
{
    return [self getRelativeContentViewForContentID:contentItem.contentID
                                          viewStyle:style
                                       successBlock:successBlock
                                       failureBlock:failureBlock];
}

+ (void) getRelativeContentViewForContentID: (NSString*) contentID
                                  viewStyle: (RelapSDKRelativeContentViewStyle) style
                               successBlock: (RelapSDKSuccessContentViewBlock) successBlock
                               failureBlock: (RelapSDKFailureBlock) failureBlock
{
    
    [self getContentRelativeToContentID:contentID
                            successBlock:^(NSArray *relativeContent) {
                            
                                RelapSDKRelativeContentView* relativeContentView = [[RelapSDKRelativeContentView alloc] initWithStyle:style];
                                
                                relativeContentView.relativeContentItems = relativeContent;
                                
                                if (successBlock) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        successBlock(relativeContentView);
                                    });
                                }
                                
                            }
                            failureBlock:failureBlock];
}


- (void) sendPacket: (NSDictionary*) packet successBlock: (RelapSDKSuccessBlock) successBlock failureBlock: (RelapSDKFailureBlock) failureBlock
{
    if (![packet isKindOfClass:[NSDictionary class]]) {
        
        NSError* error = [NSError errorWithDomain:@"RelapSDK" code:4 userInfo:@{NSLocalizedDescriptionKey: @"Packet should be NSDictionary type"}];
        
        if (failureBlock) {
            failureBlock(error);
        }
        
        return;
    }
    
    NSURL* requestUrl = [NSURL URLWithString:kRelapAPIURL];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    request.HTTPMethod = @"POST";
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    NSError* error;
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:packet options:NSJSONWritingPrettyPrinted error:&error]];
    
    if (error) {

        error = [NSError errorWithDomain:@"RelapSDK" code:5 userInfo:@{NSLocalizedDescriptionKey: @"Failed to encode packet to JSON"}];
        
        if (failureBlock) {
            failureBlock(error);
        }
        
        return;
    }
    
    RelapSDKRequestOperation* op = [[RelapSDKRequestOperation alloc] initWithRequest:request];
    if (successBlock) {
        op.successBlock = ^(RelapSDKRequestOperation* op, id response) {
            successBlock(response);
        };
    }
    
    if (failureBlock) {
        op.failureBlock = ^(RelapSDKRequestOperation* op, NSError* error) {
            failureBlock(error);
        };
    }
    
    [self.queue addOperation:op];
}

@end
