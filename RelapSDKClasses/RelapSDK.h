//
//  RelapSDK.h
//  Relap SDK
//
//  Created by Igor Kamenev on 16/12/14.
//  Copyright (c) 2014 Relap.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RelapSDKRequestOperation.h"
#import "RelapSDKContentItem.h"
#import "RelapSDKRelativeContentView.h"

typedef void (^RelapSDKSuccessBlock)(id response);
typedef void (^RelapSDKSuccessContentBlock)(NSArray* relativeContent);
typedef void (^RelapSDKFailureBlock)(NSError* error);
typedef void (^RelapSDKSuccessContentViewBlock)(RelapSDKRelativeContentView* relativeContentView);

@interface RelapSDK : NSObject

+ (void) setupWithApplicationID: (NSString*) applicationID userID: (NSString*) userID;

+ (void) markContentSeenWithContentID: (NSString*) contentID
                                title: (NSString*) title
                                 text: (NSString*) text
                             imageUrl: (NSString*) imageUrl
                              payload: (NSDictionary*) payload
                         successBlock: (RelapSDKSuccessBlock) successBlock
                         failureBlock: (RelapSDKFailureBlock) failureBlock;

+ (void) markContentSeen: (RelapSDKContentItem*) contentItem;
+ (void) markContentSeen: (RelapSDKContentItem*) contentItem
            successBlock: (RelapSDKSuccessBlock) successBlock
            failureBlock: (RelapSDKFailureBlock) failureBlock;


+ (void) getContentRelativeToContentID: (NSString*) contentID
                          successBlock: (RelapSDKSuccessContentBlock) successBlock
                          failureBlock: (RelapSDKFailureBlock) failureBlock;

+ (void) getRelativeContentViewForContentItem: (RelapSDKContentItem*) contentItem
                                    viewStyle: (RelapSDKRelativeContentViewStyle) style
                                 successBlock: (RelapSDKSuccessContentViewBlock) successBlock
                                 failureBlock: (RelapSDKFailureBlock) failureBlock;

+ (void) getRelativeContentViewForContentID: (NSString*) contentID
                                  viewStyle: (RelapSDKRelativeContentViewStyle) style
                               successBlock: (RelapSDKSuccessContentViewBlock) successBlock
                               failureBlock: (RelapSDKFailureBlock) failureBlock;

@end
