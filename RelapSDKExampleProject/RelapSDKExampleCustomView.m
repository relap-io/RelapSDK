//
//  RelapSDKExampleCustomView.m
//  RelapSDK
//
//  Created by Igor Kamenev on 27/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleCustomView.h"

static CGFloat const kPadding = 8.0;

@implementation RelapSDKExampleCustomView

-(instancetype)init
{
    return [super init];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.thumbImageView = [UIImageView new];
        self.thumbImageView.backgroundColor = [UIColor grayColor];
        self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbImageView.clipsToBounds = YES;
        [self addSubview:self.thumbImageView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
        self.titleLabel.numberOfLines = 4;
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        
        self.authorNameLabel = [UILabel new];
        self.authorNameLabel.font = [UIFont boldSystemFontOfSize:12.0];
        self.authorNameLabel.numberOfLines = 1;
        self.authorNameLabel.textColor = [UIColor blackColor];
        [self addSubview:self.authorNameLabel];
        
        self.authorAvatarImageView = [UIImageView new];
        self.authorAvatarImageView.backgroundColor = [UIColor grayColor];
        self.authorAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.authorAvatarImageView.clipsToBounds = YES;
        [self addSubview:self.authorAvatarImageView];
    }
    
    return self;
}

-(void)layoutSubviews
{
    CGRect rect;
    
    rect = self.thumbImageView.frame;
    rect.origin.x = kPadding;
    rect.origin.y = kPadding;
    rect.size.width = (self.bounds.size.width / 2.0) - kPadding/2.0;
    rect.size.height = rect.size.width / 16.0 * 9.0;
    self.thumbImageView.frame = rect;

    CGFloat x = CGRectGetMaxX(self.thumbImageView.frame) + kPadding;
    
    rect = self.authorAvatarImageView.frame;
    rect.origin.x = x;
    rect.origin.y = kPadding;
    rect.size.width = 15.0;
    rect.size.height = 15.0;
    self.authorAvatarImageView.frame = rect;
    
    rect = self.authorNameLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.authorAvatarImageView.frame) + kPadding/2.0;
    rect.origin.y = kPadding;
    rect.size.width = self.bounds.size.width - rect.origin.x - kPadding;
    self.authorNameLabel.frame = rect;
    [self.authorNameLabel sizeToFit];
    
    rect = self.titleLabel.frame;
    rect.origin.x = x;
    rect.origin.y = CGRectGetMaxY(self.authorNameLabel.frame) + kPadding;
    rect.size.width = self.bounds.size.width - rect.origin.x - kPadding*2;
    self.titleLabel.frame = rect;
    [self.titleLabel sizeToFit];
    
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGFloat imgHeight = ((self.bounds.size.width / 2.0) - kPadding/2.0) / 16.0 * 9.0 + kPadding*2.0;
    
    CGFloat contentOffsetX = (self.bounds.size.width / 2.0) - kPadding/2.0 + kPadding;
    CGFloat contentMaxWidth = self.bounds.size.width - contentOffsetX - kPadding*2.0;
    
    CGFloat contentHeight = kPadding*4.0;
    
    contentHeight += [self.authorNameLabel sizeThatFits:CGSizeMake(contentMaxWidth, CGFLOAT_MAX)].height;
    contentHeight += [self.titleLabel sizeThatFits:CGSizeMake(contentMaxWidth, CGFLOAT_MAX)].height;
    
//    contentHeight += 100;
    CGFloat height = MAX(imgHeight, contentHeight);
    height += kPadding;
    
    return CGSizeMake(height, height);
}

@end
