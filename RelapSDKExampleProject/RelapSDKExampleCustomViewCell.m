//
//  RelapSDKExampleCustomViewCell.m
//  RelapSDK
//
//  Created by Igor Kamenev on 27/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleCustomViewCell.h"

@implementation RelapSDKExampleCustomViewCell

-(void)layoutSubviews
{
    self.customView.frame = self.bounds;
}

-(void)setCustomView:(RelapSDKExampleCustomView *)customView
{
    if (_customView) {
        [_customView removeFromSuperview];
    }
    
    _customView = customView;
    
    [self.contentView addSubview:customView];
}

@end
