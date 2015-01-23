//
//  RelapSDKRelativeContentView.h
//  surfingbird
//
//  Created by Igor Kamenev on 19/01/15.
//  Copyright (c) 2015 surfingbird. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    RelapSDKRelativeContentViewStyleVerticalAlignmentVerticalItem,
    RelapSDKRelativeContentViewStyleVerticalAlignmentHorizontalItem,
    RelapSDKRelativeContentViewStyleHorizontalAlignmentVerticalItem,
    RelapSDKRelativeContentViewStyleHorizontalAlignmentHorizontalItem
    
} RelapSDKRelativeContentViewStyle;

@interface RelapSDKRelativeContentView : UIView {
    CGFloat _padding;
    CGFloat _imageAspectRatio;
}
-(instancetype) initWithStyle:(RelapSDKRelativeContentViewStyle) style;

@property (nonatomic) RelapSDKRelativeContentViewStyle style;
@property (nonatomic, strong) NSArray* relativeContentItems;

@property (nonatomic) CGFloat imageAspectRatio;
@property (nonatomic) CGFloat padding;

@property (nonatomic, strong) UIFont* titleFont;
@property (nonatomic, strong) UIColor* titleColor;

@property (nonatomic, strong) UIFont* textFont;
@property (nonatomic, strong) UIColor* textColor;

@property (nonatomic, copy) UIColor* pageIndicatorTintColor;
@property (nonatomic, copy) UIColor* currentPageIndicatorTintColor;

@end

@protocol RelapSDKRelativeContentViewDelegate <NSObject>

@optional
-(void) relapSDKR

@end
