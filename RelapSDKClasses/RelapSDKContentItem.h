//
//  RelapSDKContentItem.h
//  surfingbird
//
//  Created by Igor Kamenev on 12/01/15.
//  Copyright (c) 2015 surfingbird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelapSDKContentItem : NSObject

@property (nonatomic, strong) NSString* contentID;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* imageURL;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSDictionary* payload;

-(instancetype) initWithDict: (NSDictionary*) dict;

@end
