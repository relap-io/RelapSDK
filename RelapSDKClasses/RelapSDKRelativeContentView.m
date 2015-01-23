//
//  RelapSDKRelativeContentView.m
//  surfingbird
//
//  Created by Igor Kamenev on 19/01/15.
//  Copyright (c) 2015 surfingbird. All rights reserved.
//

#import "RelapSDKRelativeContentView.h"
#import "RelapSDKRelativeContentItemView.h"

@interface RelapSDKRelativeContentView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray* itemViews;
@property (nonatomic, strong) UIScrollView* relativeItemContainer;
@property (nonatomic) CGFloat lastLayoutWidth;
@property (nonatomic, strong) UIPageControl* pageControl;

@end

static CGFloat const kRelapSDKContentItemViewDefaultPadding = 5.0;
static CGFloat const kRelapSDKContentItemViewDefaultImageAspectRatio = 16.0/9.0;

@implementation RelapSDKRelativeContentView

-(instancetype) initWithStyle:(RelapSDKRelativeContentViewStyle) style
{
    self = [super init];
    
    if (self) {
        
        self.relativeItemContainer = [[UIScrollView alloc] init];
        self.relativeItemContainer.showsHorizontalScrollIndicator = NO;
        self.relativeItemContainer.showsVerticalScrollIndicator = NO;
        self.relativeItemContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.relativeItemContainer.delegate = self;
        
        [self addSubview:self.relativeItemContainer];

        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        
        self.style = style;
        self.itemViews = [NSMutableArray new];
        
        self.padding = -1;
        self.imageAspectRatio = 16.0 / 9.0;

        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont boldSystemFontOfSize:14.0];
        
        self.textColor = [UIColor grayColor];
        self.textFont = [UIFont systemFontOfSize:12.0];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    
    [self sizeToFit];
    
    if (
        self.style == RelapSDKRelativeContentViewStyleVerticalAlignmentHorizontalItem ||
        self.style == RelapSDKRelativeContentViewStyleVerticalAlignmentVerticalItem
    ) {
        
        [self layoutSubviewsForVerticalStyle];
        
    } else {

        [self layoutSubviewsForHorizontalStyle];
        
    }
}

-(void)layoutSubviewsForVerticalStyle
{
    CGRect rect;
    CGFloat offsetY = 0.0;
    
    for (RelapSDKRelativeContentItemView* itemView in self.itemViews) {
        
        rect = itemView.frame;
        rect.origin.x = 0;
        rect.origin.y = offsetY;
        rect.size.width = self.bounds.size.width;
        itemView.frame = rect;
        [itemView sizeToFit];
        
        offsetY += itemView.frame.size.height;
    }
    
    self.relativeItemContainer.frame = self.bounds;
    self.relativeItemContainer.scrollEnabled = NO;
    self.relativeItemContainer.scrollsToTop = NO;

    self.pageControl.hidden = YES;
}

-(void)layoutSubviewsForHorizontalStyle
{
    CGRect rect;
    CGFloat offsetX = 0.0;
    
    for (RelapSDKRelativeContentItemView* itemView in self.itemViews) {
        
        rect = itemView.frame;
        rect.origin.x = offsetX;
        rect.origin.y = 0;
        rect.size.width = self.bounds.size.width;
        itemView.frame = rect;
        [itemView sizeToFit];
        
        offsetX += itemView.frame.size.width;
    }
    
    self.relativeItemContainer.frame = self.bounds;
    self.relativeItemContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.relativeItemContainer.scrollEnabled = YES;
    self.relativeItemContainer.scrollsToTop = NO;
    self.relativeItemContainer.contentSize = CGSizeMake(offsetX, self.bounds.size.height);
    self.relativeItemContainer.pagingEnabled = YES;
    
    if (self.lastLayoutWidth == 0.0) {
        self.relativeItemContainer.contentOffset = CGPointZero;
    } else {
        
        CGPoint point = self.relativeItemContainer.contentOffset;
        int previousPageNum = point.x / self.lastLayoutWidth;
        
        self.relativeItemContainer.contentOffset = CGPointMake(previousPageNum * self.relativeItemContainer.bounds.size.width, 0);
        
    }

    self.lastLayoutWidth = self.bounds.size.width;
    
    rect = self.pageControl.frame;
    rect.origin.y = self.bounds.size.height - rect.size.height;
    self.pageControl.frame = rect;
    self.pageControl.hidden = NO;
    
}

-(void)addRelativeItemViews
{
    for (UIView* view in [self.itemViews copy]) {
        [view removeFromSuperview];
    }
    self.itemViews = [NSMutableArray new];
    
    for (RelapSDKContentItem* item in self.relativeContentItems) {
        
        RelapSDKRelativeContentItemViewStyle itemStyle = (self.style == RelapSDKRelativeContentViewStyleHorizontalAlignmentHorizontalItem || self.style == RelapSDKRelativeContentViewStyleVerticalAlignmentHorizontalItem) ? RelapSDKRelativeContentItemViewStyleHorizontal : RelapSDKRelativeContentItemViewStyleVertical;
        
        RelapSDKRelativeContentItemView* itemView = [[RelapSDKRelativeContentItemView alloc] initWithStyle:itemStyle];

        itemView.titleFont = self.titleFont;
        itemView.titleColor = self.titleColor;
        itemView.textFont = self.textFont;
        itemView.textColor = self.textColor;
        itemView.imageAspectRatio = self.imageAspectRatio;
        itemView.padding = self.padding;

        itemView.contentItem = item;
        
        [self.relativeItemContainer addSubview:itemView];
        [self.itemViews addObject:itemView];
    }
    
    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.relativeContentItems.count;
    
}

-(void)setRelativeContentItems:(NSArray *)relativeContentItems
{
    @synchronized(self) {
        _relativeContentItems = relativeContentItems;
        [self addRelativeItemViews];
        [self setNeedsLayout];
    }
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = 0.0;
    
    if (
        self.style == RelapSDKRelativeContentViewStyleVerticalAlignmentHorizontalItem ||
        self.style == RelapSDKRelativeContentViewStyleVerticalAlignmentVerticalItem
        ) {
        
        for (RelapSDKRelativeContentItemView* itemView in self.itemViews) {
            
            height += [itemView sizeThatFits:size].height;
        }
        
    } else {
        
        for (RelapSDKRelativeContentItemView* itemView in self.itemViews) {
            
            height = MAX([itemView sizeThatFits:size].height, height);
        }
        
        height += self.pageControl.frame.size.height;
    }

    return CGSizeMake(size.width,height);
}

-(void)setPadding:(CGFloat)padding
{
    _padding = padding;
    self.relativeContentItems = self.relativeContentItems;
}

-(CGFloat)padding
{
    if (_padding >= 0) {
        return _padding;
    } else {
        return kRelapSDKContentItemViewDefaultPadding;
    }
}

-(void)setImageAspectRatio:(CGFloat)imageAspectRatio
{
    _imageAspectRatio = imageAspectRatio;
    self.relativeContentItems = self.relativeContentItems;
}

-(CGFloat)imageAspectRatio
{
    if (_imageAspectRatio != -1) {
        return _imageAspectRatio;
    } else {
        return kRelapSDKContentItemViewDefaultImageAspectRatio;
    }
}

-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.relativeContentItems = self.relativeContentItems;
}

-(void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    self.relativeContentItems = self.relativeContentItems;
}

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

-(UIColor *)pageIndicatorTintColor
{
    return self.pageControl.pageIndicatorTintColor;
}

-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

-(UIColor *)currentPageIndicatorTintColor
{
    return self.pageControl.currentPageIndicatorTintColor;
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int curPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageControl.currentPage = curPage;
}

@end
