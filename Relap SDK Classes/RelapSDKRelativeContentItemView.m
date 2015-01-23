//
//  RelapSDKRelativeContentItemView.m
//  surfingbird
//
//  Created by Igor Kamenev on 19/01/15.
//  Copyright (c) 2015 surfingbird. All rights reserved.
//

#import "RelapSDKRelativeContentItemView.h"

@interface RelapSDKRelativeContentItemView ()

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* textLabel;

@end

@implementation RelapSDKRelativeContentItemView

-(instancetype) initWithStyle: (RelapSDKRelativeContentItemViewStyle) style
{
    self = [super init];
    
    if (self) {
        self.style = style;
        
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.backgroundColor = [UIColor colorWithWhite:194.0/255.0 alpha:1.0];
        [self addSubview: self.imageView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.numberOfLines = 2;
        [self addSubview:self.titleLabel];
        
        self.textLabel = [UILabel new];
        self.textLabel.numberOfLines = 3;
        [self addSubview:self.textLabel];
        
    }
    
    return self;
}

-(void)layoutSubviews
{

    if (self.style == RelapSDKRelativeContentItemViewStyleVertical) {
        [self layoutSubviewsForVerticalStyle];
    } else {
        [self layoutSubviewsForHorizontalStyle];
    }
    
}

-(void)layoutSubviewsForHorizontalStyle
{

    CGRect rect;
    
    rect = self.imageView.frame;
    rect.origin.x = self.padding;
    rect.origin.y = self.padding;
    rect.size.width = (self.bounds.size.width / 2.0) - self.padding - self.padding / 2.0;
    rect.size.height = rect.size.width / self.imageAspectRatio;
    self.imageView.frame = rect;
    
    CGFloat x = self.imageView.bounds.size.width + self.padding;
    CGFloat y = 0.0;
    
    if (self.contentItem.title) {
        rect = self.titleLabel.frame;
        rect.origin.x = x + self.padding;
        rect.origin.y = y + self.padding;
        rect.size.width = (self.bounds.size.width / 2.0) - self.padding - self.padding / 2.0;
        self.titleLabel.frame = rect;
        
        [self.titleLabel sizeToFit];
        
        y = CGRectGetMaxY(self.titleLabel.frame);
    }
    
    if (self.contentItem.text) {
        rect = self.textLabel.frame;
        rect.origin.x = x + self.padding;
        rect.origin.y = y + self.padding;
        rect.size.width = (self.bounds.size.width / 2.0) - self.padding - self.padding / 2.0;
        self.textLabel.frame = rect;
        
        [self.textLabel sizeToFit];
        
        y = CGRectGetMaxY(self.textLabel.frame);
    }
}

-(void)layoutSubviewsForVerticalStyle
{
    CGRect rect;
    CGFloat y = 0.0;
    
    rect = self.imageView.frame;
    rect.origin.x = self.padding;
    rect.origin.y = y + self.padding;
    rect.size.width = self.bounds.size.width - self.padding*2;
    rect.size.height = rect.size.width / self.imageAspectRatio;
    self.imageView.frame = rect;
    
    y = CGRectGetMaxY(self.imageView.frame);
    
    if (self.contentItem.title) {
        
        rect = self.titleLabel.frame;
        rect.origin.x = self.padding;
        rect.origin.y = y + self.padding;
        rect.size.width = self.bounds.size.width - self.padding*2;
        self.titleLabel.frame = rect;
        
        [self.titleLabel sizeToFit];
        
        y = CGRectGetMaxY(self.titleLabel.frame);
        
    }
    
    if (self.contentItem.text) {
        
        rect = self.textLabel.frame;
        rect.origin.x = self.padding;
        rect.origin.y = y + self.padding;
        rect.size.width = self.bounds.size.width - self.padding*2;
        self.textLabel.frame = rect;
        
        [self.textLabel sizeToFit];
        
        y = CGRectGetMaxY(self.textLabel.frame);
        
    }
}


-(void)setContentItem:(RelapSDKContentItem *)contentItem
{
    _contentItem = contentItem;

    if (self.contentItem.imageURL) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
           
            NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.contentItem.imageURL]];
            UIImage* image = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    self.imageView.image = image;
                } else {
                    self.imageView.image = [UIImage imageNamed:@"RelapSDKNoPhoto"];
                }
            });
        });
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageNamed:@"RelapSDKNoPhoto.png"];
        });
    }
    
    if (contentItem.title)
        self.titleLabel.text = contentItem.title;
    
    if (contentItem.text)
        self.textLabel.text = contentItem.text;
    
    [self setNeedsLayout];
}

-(void)setTextFont:(UIFont *)textFont
{
    self.textLabel.font = textFont;
}

-(UIFont *)textFont
{
    return self.textLabel.font;
}

-(void)setTitleFont:(UIFont *)titleFont
{
    self.titleLabel.font = titleFont;
}

-(UIFont *)titleFont
{
    return self.titleLabel.font;
}

-(void)setTextColor:(UIColor *)textColor
{
    self.textLabel.textColor = textColor;
}

-(UIColor *)textColor
{
    return self.textLabel.textColor;
}

-(void)setTitleColor:(UIColor *)titleColor
{
    self.titleLabel.textColor = titleColor;
}

-(UIColor *)titleColor
{
    return self.titleLabel.textColor;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    if (self.style == RelapSDKRelativeContentItemViewStyleHorizontal) {
        return [self sizeThatFitsForHorizontalStyle:size];
    } else {
        return [self sizeThatFitsForVerticalStyle:size];
    }
}

-(CGSize)sizeThatFitsForVerticalStyle:(CGSize) size
{
    CGFloat height = self.padding;
    
    if (self.contentItem.imageURL) {
        height += self.padding + ((size.width - self.padding*2) / self.imageAspectRatio);
    }
    
    if (self.contentItem.title) {
        
        CGSize maxSize = CGSizeMake(size.width-self.padding*2, CGFLOAT_MAX);
        CGSize newSize = [self.titleLabel sizeThatFits:maxSize];
        height += self.padding + newSize.height;
        
    }
    
    if (self.contentItem.text) {
        
        CGSize maxSize = CGSizeMake(size.width-self.padding*2, CGFLOAT_MAX);
        CGSize newSize = [self.textLabel sizeThatFits:maxSize];
        height += self.padding + newSize.height;
    }
    
    return CGSizeMake(size.width, height);
}

-(CGSize)sizeThatFitsForHorizontalStyle:(CGSize) size
{

    CGFloat imageHeight = ((size.width / 2.0) - self.padding - self.padding / 2.0) / self.imageAspectRatio + self.padding*2;
    CGFloat textHeight = 0.0;

    CGFloat maxWidth = (size.width / 2.0) - self.padding - self.padding / 2.0;
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    
    if (self.contentItem.title) {
        
        CGSize newSize = [self.titleLabel sizeThatFits:maxSize];
        textHeight += self.padding + newSize.height;
        
    }
    
    if (self.contentItem.text) {
        
        CGSize newSize = [self.textLabel sizeThatFits:maxSize];
        textHeight += self.padding + newSize.height;
    }
    
    textHeight += self.padding*2;
    imageHeight += self.padding*2;
        
    return CGSizeMake(size.width, MAX(imageHeight, textHeight));
}

@end
