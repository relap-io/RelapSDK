//
//  RelapSDKExampleArticleView.m
//  RelapSDK
//
//  Created by Igor Kamenev on 22/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleArticleView.h"

static CGFloat const kPadding = 8.0;

@implementation RelapSDKExampleArticleView

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
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        
        self.descriptionLabel = [UILabel new];
        self.descriptionLabel.font = [UIFont systemFontOfSize:13.0];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.descriptionLabel];
    }
    
    return self;
}

-(void)layoutSubviews
{
    CGRect rect;
    
    rect = self.thumbImageView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = self.bounds.size.width;
    rect.size.height = self.bounds.size.width / 16.0 * 9.0;
    self.thumbImageView.frame = rect;
    
    rect = self.titleLabel.frame;
    rect.origin.x = kPadding;
    rect.origin.y = CGRectGetMaxY(self.thumbImageView.frame) + kPadding;
    rect.size.width = self.bounds.size.width - kPadding*2;
    self.titleLabel.frame = rect;
    [self.titleLabel sizeToFit];
    
    rect = self.descriptionLabel.frame;
    rect.origin.x = kPadding;
    rect.origin.y = CGRectGetMaxY(self.titleLabel.frame) + kPadding;
    rect.size.width = self.bounds.size.width - kPadding*2;
    self.descriptionLabel.frame = rect;
    [self.descriptionLabel sizeToFit];
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = self.bounds.size.width / 16.0 * 9.0;
    
    height += kPadding*3;
    height += [self.titleLabel sizeThatFits:CGSizeMake(self.bounds.size.width - kPadding*2, CGFLOAT_MAX)].height;
    height += [self.descriptionLabel sizeThatFits:CGSizeMake(self.bounds.size.width - kPadding*2, CGFLOAT_MAX)].height;
    
    return CGSizeMake(size.width, height);
}

@end
