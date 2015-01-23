//
//  RelapSDKContentItem.m
//  surfingbird
//
//  Created by Igor Kamenev on 12/01/15.
//  Copyright (c) 2015 surfingbird. All rights reserved.
//

#import "RelapSDKContentItem.h"

@implementation RelapSDKContentItem

-(instancetype) initWithDict: (NSDictionary*) dict
{
    self = [super init];
    
    if (self) {
        
        self.contentID = [self stringValueFromDict:dict byKey:@"contentID"];
        self.title = [self stringValueFromDict:dict byKey:@"title"];
        self.imageURL = [self stringValueFromDict:dict byKey:@"imageUrl"];
        self.text = [self stringValueFromDict:dict byKey:@"text"];
        
        if ([dict objectForKey:@"payload"])
            self.payload = [dict objectForKey:@"payload"];
        
    }
    
    return self;
}

- (NSString*) stringValueFromDict: (NSDictionary*) dict byKey: (id) key
{
    if (!key)
        return nil;
    
    id value = [dict objectForKey:key];
    if (!value)
        return nil;
    
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"ContentID: %@, title: %@", self.contentID, self.title];
}

@end
