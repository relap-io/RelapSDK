//
//  RelapSDKExampleArticleViewController.m
//  RelapSDK
//
//  Created by Igor Kamenev on 22/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleArticleViewController.h"
#import "RelapSDKExampleArticleCell.h"
#import "RelapSDKExampleRelativeContentCell.h"
#import "RelapSDK.h"
#import "RelapSDKExampleImageLoadingOperationQueue.h"

@interface RelapSDKExampleArticleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary* dict;
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) RelapSDKRelativeContentView* relativeContentView;
@property (nonatomic, strong) RelapSDKExampleArticleView* articleView;

@property (nonatomic, strong) RelapSDKContentItem* contentItem;

@end

static NSString* const kArticleCellIdentifier = @"kArticleCellIdentifier";
static NSString* const kRelativeContentCellIdentifier = @"kRelativeContentCellIdentifier";

@implementation RelapSDKExampleArticleViewController

-(instancetype)initWithDict: (NSDictionary*) dict
{
    self = [super init];
    
    if (self) {
        self.dict = dict;
    }
    
    self.contentItem = [[RelapSDKContentItem alloc] init];
    self.contentItem.contentID = dict[@"guid"];
    self.contentItem.title = dict[@"title"];
    self.contentItem.text = dict[@"description"];
    self.contentItem.imageURL = dict[@"enclosure"][@"_url"];
    
    [RelapSDK markContentSeen:self.contentItem];
    
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
    [self.tableView registerClass:[RelapSDKExampleRelativeContentCell class] forCellReuseIdentifier:kRelativeContentCellIdentifier];
    
    [self.view addSubview:self.tableView];

    [RelapSDK getRelativeContentViewForContentID:self.contentItem.contentID viewStyle:[self style] successBlock:^(RelapSDKRelativeContentView *relativeContentView) {
        
        self.relativeContentView = relativeContentView;
        [self.tableView reloadData];
        
    } failureBlock:nil];
    
}

-(RelapSDKRelativeContentViewStyle) style
{
    if (self.styleTag == 0) {
        return RelapSDKRelativeContentViewStyleHorizontalAlignmentHorizontalItem;
    }
    
    if (self.styleTag == 1) {
        return RelapSDKRelativeContentViewStyleHorizontalAlignmentVerticalItem;
    }
    
    if (self.styleTag == 2) {
        return RelapSDKRelativeContentViewStyleVerticalAlignmentHorizontalItem;
    }
    
    if (self.styleTag == 3) {
        return RelapSDKRelativeContentViewStyleVerticalAlignmentVerticalItem;
    }
    
    return -1;
}

#pragma mark UITableViewDataSource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.relativeContentView ? 2 : 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

        return [[self articleView] sizeThatFits:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX)].height;
    
    }
    
    else if (indexPath.row == 1) {

        return [self.relativeContentView sizeThatFits:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX)].height + 30.0;
        
    }
    
    return 20;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        RelapSDKExampleArticleCell* cell = [tableView dequeueReusableCellWithIdentifier:kArticleCellIdentifier forIndexPath:indexPath];
        
        cell.articleView = [self articleView];
        
        return cell;
    }

    else if (indexPath.row == 1) {
        RelapSDKExampleRelativeContentCell* cell = [self.tableView dequeueReusableCellWithIdentifier:kRelativeContentCellIdentifier];
        cell.relativeContentView = self.relativeContentView;
        return cell;
    }
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
