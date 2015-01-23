//
//  RelapSDKExampleRelativeContentCell.m
//  RelapSDK
//
//  Created by Igor Kamenev on 22/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleRelativeContentCell.h"

@interface RelapSDKExampleRelativeContentCell ()

@property (nonatomic, strong) UILabel* label;

@end

static CGFloat const kPadding = 8.0;

@implementation RelapSDKExampleRelativeContentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont boldSystemFontOfSize:14.0];
        self.label.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.label.text = @"Читайте также:";
        [self addSubview:self.label];
    }
    
    return self;
}

-(void)layoutSubviews
{

    [self.label sizeToFit];
    CGRect rect = self.label.frame;
    rect.origin.x = kPadding;
    rect.origin.y = kPadding;
    self.label.frame = rect;
    
    rect = self.relativeContentView.frame;
    rect.origin.x = 0;
    rect.origin.y = CGRectGetMaxY(self.label.frame);
    rect.size.width = self.bounds.size.width;
    rect.size.height = self.bounds.size.height - rect.origin.y;
    self.relativeContentView.frame = rect;
    [self.relativeContentView sizeToFit];
}

-(void)setRelativeContentView:(RelapSDKRelativeContentView *)relativeContentView
{
    _relativeContentView = relativeContentView;
    [self addSubview:_relativeContentView];
    [self setNeedsLayout];
}

@end
