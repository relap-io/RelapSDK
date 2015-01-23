//
//  RelapSDKExampleArticlePreviewCell.m
//  RelapSDK
//
//  Created by Igor Kamenev on 22/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleArticlePreviewCell.h"
#import "RelapSDKExampleImageLoadingOperationQueue.h"

@interface RelapSDKExampleArticlePreviewCell ()

@property (nonatomic, strong, readwrite) UIImageView* thumbImageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* descriptionLabel;

@end

static CGFloat const kPadding = 8.0;

@implementation RelapSDKExampleArticlePreviewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.thumbImageView = [UIImageView new];
        self.thumbImageView.backgroundColor = [UIColor grayColor];
        self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbImageView.clipsToBounds = YES;
        [self addSubview:self.thumbImageView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        
        self.descriptionLabel = [UILabel new];
        self.descriptionLabel.font = [UIFont systemFontOfSize:13.0];
        self.descriptionLabel.numberOfLines = 3;
        self.descriptionLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.descriptionLabel];
    }
    
    return self;
}

-(void)layoutSubviews
{
    CGRect rect;
    
    rect = self.thumbImageView.frame;
    rect.origin.x = kPadding;
    rect.origin.y = kPadding;
    rect.size.width = self.bounds.size.width / 3.0;
    rect.size.height = self.bounds.size.width / 4.0;
    self.thumbImageView.frame = rect;
    
    rect = self.titleLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.thumbImageView.frame) + kPadding;
    rect.origin.y = kPadding;
    rect.size.width = self.bounds.size.width - rect.origin.x - kPadding;
    self.titleLabel.frame = rect;
    [self.titleLabel sizeToFit];
    
    
    rect = self.descriptionLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.thumbImageView.frame) + kPadding;
    rect.origin.y = CGRectGetMaxY(self.titleLabel.frame) + kPadding;
    rect.size.width = self.bounds.size.width - rect.origin.x - kPadding;
    self.descriptionLabel.frame = rect;
    [self.descriptionLabel sizeToFit];
}

-(void)prepareForReuse
{
    self.thumbImageView.image = nil;
}

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.titleLabel.text = dict[@"title"];
    self.descriptionLabel.text = dict[@"description"];
    
    if (dict[@"enclosure"] && dict[@"enclosure"][@"_url"] && [dict[@"enclosure"][@"_type"] isEqualToString:@"image/jpeg"]) {
        
        NSString* imagePath = dict[@"enclosure"][@"_url"];
        
        [[RelapSDKExampleImageLoadingOperationQueue sharedQueue] addOperationWithBlock:^{
            
            NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imagePath]];
            UIImage* image = [[UIImage alloc] initWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.dict[@"enclosure"][@"_url"] isEqualToString:imagePath]) {
                        self.thumbImageView.image = image;
                    }
                });
            } else {
                self.thumbImageView.image = nil;
            }
        }];
    }
    
    [self setNeedsLayout];
}

@end
