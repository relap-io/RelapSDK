//
//  RelapSDKExampleArticleListViewController.m
//  RelapSDK
//
//  Created by Igor Kamenev on 21/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleArticleListViewController.h"
#import "XMLDictionary.h"
#import "RelapSDKExampleArticlePreviewCell.h"
#import "RelapSDKExampleArticleViewController.h"

@interface RelapSDKExampleArticleListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray* articles;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, strong) UITableView* tableView;

@end

static NSString* const kArticlePreviewCellIdentifier = @"kArticlePreviewCellIdentifier";

@implementation RelapSDKExampleArticleListViewController

-(void)viewDidLoad
{
    self.title = @"Article list";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[RelapSDKExampleArticlePreviewCell class] forCellReuseIdentifier:kArticlePreviewCellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.activityIndicatorView = [UIActivityIndicatorView new];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicatorView];
    
    [self loadArticles];
}

-(void)viewWillLayoutSubviews
{
    self.activityIndicatorView.center = self.view.center;
}

-(void)loadArticles
{
    
    [self.activityIndicatorView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        NSURL* url = [NSURL URLWithString:@"http://www.lenta.ru/rss"];
        NSError* error;
        NSString* string = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];

        NSDictionary* dict = [NSDictionary dictionaryWithXMLString:string];
        

        if (!dict || !dict[@"channel"][@"item"]) {
            NSLog(@"Error: wrong XML file from lenta.ru");
        }

        NSMutableArray* articles = [NSMutableArray new];
        for (NSDictionary* article in dict[@"channel"][@"item"]) {
            [articles addObject:article];
        }

        self.articles = [articles copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didLoadArticles];
        });
    });
}

-(void)didLoadArticles
{
    [self.activityIndicatorView stopAnimating];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.width / 4.0 + 16.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelapSDKExampleArticlePreviewCell* cell = [tableView dequeueReusableCellWithIdentifier:kArticlePreviewCellIdentifier forIndexPath:indexPath];

    NSDictionary* dict = self.articles[indexPath.row];
    cell.dict = dict;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dict = self.articles[indexPath.row];
    
    if (self.styleTag < 5) {
        RelapSDKExampleArticleViewController* vc = [[RelapSDKExampleArticleViewController alloc] initWithDict:dict];
        vc.styleTag = self.styleTag;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
