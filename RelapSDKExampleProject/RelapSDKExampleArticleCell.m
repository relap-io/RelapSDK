//
//  RelapSDKExampleArticleCell.m
//  RelapSDK
//
//  Created by Igor Kamenev on 22/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleArticleCell.h"

@implementation RelapSDKExampleArticleCell

-(void)setArticleView:(RelapSDKExampleArticleView *)articleView
{
    if (_articleView) {
        [_articleView removeFromSuperview];
    }
    
    _articleView = articleView;
    
    [self.contentView addSubview:articleView];
}

@end
