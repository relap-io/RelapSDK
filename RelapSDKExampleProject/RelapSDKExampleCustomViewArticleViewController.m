//
//  RelapSDKExampleCustomViewArticleViewController.m
//  RelapSDK
//
//  Created by Igor Kamenev on 27/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleCustomViewArticleViewController.h"
#import "RelapSDK.h"
#import "RelapSDKExampleImageLoadingOperationQueue.h"
#import "RelapSDKExampleArticleCell.h"
#import "RelapSDKExampleCustomViewCell.h"

@interface RelapSDKExampleCustomViewArticleViewController () <
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) NSDictionary* dict;
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) RelapSDKExampleArticleView* articleView;
@property (nonatomic, strong) RelapSDKRelativeContentItem* contentItem;

@property (nonatomic, strong) NSArray* relativeContentItems;

@end

static NSString* const kArticleCellIdentifier = @"kArticleCellIdentifier";
static NSString* const kCustomViewCellIdentifier = @"kCustomViewCellIdentifier";

@implementation RelapSDKExampleCustomViewArticleViewController

-(instancetype)initWithDict: (NSDictionary*) dict
{
    self = [super init];
    
    if (self) {
        self.dict = dict;
    }
    
    [RelapSDK setupWithApplicationID:@"RelapSDKExampleProjectCustomView" userID:@"1"];
    
    self.contentItem = [[RelapSDKRelativeContentItem alloc] init];
    self.contentItem.contentID = dict[@"guid"];
    self.contentItem.title = dict[@"title"];
    self.contentItem.text = dict[@"description"];
    self.contentItem.imageURL = dict[@"enclosure"][@"_url"];
    self.contentItem.payload = @{
                                 @"author" : @"Igor Kamenev",
                                 @"avatarUrl" : @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/v/t1.0-1/c32.32.397.397/s100x100/296956_173683719380667_1556660855_n.jpg?oh=531b1873d51e96276881c40bf5e75ea1&oe=5525524A&__gda__=1431426841_c346df57c7d49d5da79a52f9908719d1"
                                 };
    
    [RelapSDK markContentSeen:self.contentItem];
    
    [RelapSDK loadContentRelativeToContentID:self.contentItem.contentID successBlock:^(NSArray *relativeContent) {
        
        self.relativeContentItems = [relativeContent copy];
        [self.tableView reloadData];
        
    } failureBlock:nil];
    
    return self;
}

-(void)viewDidLoad
{
    
    self.title = self.dict[@"title"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[RelapSDKExampleArticleCell class] forCellReuseIdentifier:kArticleCellIdentifier];
    [self.tableView registerClass:[RelapSDKExampleCustomViewCell class] forCellReuseIdentifier:kCustomViewCellIdentifier];
    [self.view addSubview:self.tableView];
    
    [RelapSDK markContentSeen:self.contentItem];
    
}

#pragma mark UITableViewDataSource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsCount = 1; // article cell
    
    if (self.relativeContentItems.count) {
//        rowsCount += 1; // "Читайте также" cell
        rowsCount += self.relativeContentItems.count; // for each content item
    }
    
    return rowsCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    if (indexPath.row == 0) {
        height = [[self articleView] sizeThatFits:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX)].height;
    } else {
        RelapSDKExampleCustomView* contentView = [self customViewForIndexPath:indexPath shouldLoadImage:NO];
        height = [contentView sizeThatFits:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX)].height;
        
    }
    
    
    return height;
}

-(RelapSDKExampleArticleView*) articleView
{
    if (!_articleView) {
        _articleView = [[RelapSDKExampleArticleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        
        _articleView.titleLabel.text = self.dict[@"title"];
        _articleView.descriptionLabel.text = self.dict[@"description"];
        
        if (self.dict[@"enclosure"]
            && self.dict[@"enclosure"][@"_url"]
            && [self.dict[@"enclosure"][@"_type"] isEqualToString:@"image/jpeg"]
            ) {
            
            NSString* imagePath = self.dict[@"enclosure"][@"_url"];
            
            [[RelapSDKExampleImageLoadingOperationQueue sharedQueue] addOperationWithBlock:^{
                
                NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imagePath]];
                UIImage* image = [[UIImage alloc] initWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.dict[@"enclosure"][@"_url"] isEqualToString:imagePath]) {
                            _articleView.thumbImageView.image = image;
                        }
                    });
                } else {
                    _articleView.thumbImageView.image = nil;
                }
            }];
        }
    }
    
    return _articleView;
}

-(RelapSDKExampleCustomView*) customViewForIndexPath: (NSIndexPath*) indexPath shouldLoadImage:(BOOL) shouldLoadImage
{
    NSInteger idx = indexPath.row-1;
    
    if (idx >= self.relativeContentItems.count) {
        return nil;
    }
    
    RelapSDKRelativeContentItem* contentItem = self.relativeContentItems[idx];
    
    RelapSDKExampleCustomView* customView = [[RelapSDKExampleCustomView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];

    customView.titleLabel.text = contentItem.title;
    customView.authorNameLabel.text = contentItem.payload[@"author"];
    
    if (shouldLoadImage) {
        
        // avatar URL
        [[RelapSDKExampleImageLoadingOperationQueue sharedQueue] addOperationWithBlock:^{
            
            NSURL* avatarURL = [NSURL URLWithString:contentItem.payload[@"avatarUrl"]];
            
            NSData* data = [[NSData alloc] initWithContentsOfURL:avatarURL];
            UIImage* image = [[UIImage alloc] initWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    customView.authorAvatarImageView.image = image;
                });
            } else {
                customView.authorAvatarImageView.image = nil;
            }
        }];
        
        
        // image
        [[RelapSDKExampleImageLoadingOperationQueue sharedQueue] addOperationWithBlock:^{
            
            NSURL* avatarURL = [NSURL URLWithString:contentItem.imageURL];
            
            NSData* data = [[NSData alloc] initWithContentsOfURL:avatarURL];
            UIImage* image = [[UIImage alloc] initWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    customView.thumbImageView.image = image;
                });
            } else {
                customView.thumbImageView.image = nil;
            }
        }];
        
        
    }
    
    return customView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        RelapSDKExampleArticleCell* cell = [tableView dequeueReusableCellWithIdentifier:kArticleCellIdentifier forIndexPath:indexPath];
        
        cell.articleView = [self articleView];
        
        return cell;
    }
    else {
    
        RelapSDKExampleCustomViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCustomViewCellIdentifier forIndexPath:indexPath];

        cell.customView = [self customViewForIndexPath: indexPath shouldLoadImage:YES];
        [cell.customView sizeToFit];
        
        return cell;
    }
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
