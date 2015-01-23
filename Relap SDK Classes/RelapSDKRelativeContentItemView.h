//
//  RelapSDKRelativeContentItemView.h
//  surfingbird
//
//  Created by Igor Kamenev on 19/01/15.
//  Copyright (c) 2015 surfingbird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelapSDKContentItem.h"

typedef enum {
    RelapSDKRelativeContentItemViewStyleVertical,
    RelapSDKRelativeContentItemViewStyleHorizontal,
} RelapSDKRelativeContentItemViewStyle;

@interface RelapSDKRelativeContentItemView : UIView

@property (nonatomic) RelapSDKRelativeContentItemViewStyle style;
@property (nonatomic, strong) RelapSDKContentItem* contentItem;

@property (nonatomic) CGFloat imageAspectRatio;
@property (nonatomic) CGFloat padding;

@property (nonatomic, copy) UIFont* titleFont;
@property (nonatomic, copy) UIColor* titleColor;

@property (nonatomic, copy) UIFont* textFont;
@property (nonatomic, copy) UIColor* textColor;

-(instancetype) initWithStyle: (RelapSDKRelativeContentItemViewStyle) style;


@end
