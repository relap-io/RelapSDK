//
//  RelapSDKExampleSelectStyleViewController.m
//  RelapSDK
//
//  Created by Igor Kamenev on 22/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "RelapSDKExampleSelectStyleViewController.h"
#import "RelapSDKExampleArticleListViewController.h"

@interface RelapSDKExampleSelectStyleViewController ()

@end

@implementation RelapSDKExampleSelectStyleViewController

-(void)viewDidLoad
{

    self.title = @"Select style";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray* styles = @[
                        @"Horizontal alignment horizontal item",
                        @"Horizontal alignment vertical item",
                        @"Vertical alignment horizontal item",
                        @"Vertical alignment vertical item",
                        ];
    
    CGFloat y = 100.0;
    CGRect rect;
    int idx = 0;
    
    for (NSString* buttonTitle in styles) {
        
        UIButton* button = [self buttonWithTitle: buttonTitle];
        rect = CGRectMake(32.0, y, self.view.bounds.size.width-64.0, 44.0);
        button.frame = rect;
        button.tag = idx++;
        [button addTarget:self action:@selector(didButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        y += 60.0;
    }
    
}

-(UIButton*)buttonWithTitle:(NSString*)title
{
    UIButton* button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.layer.borderColor = [[UIColor grayColor] CGColor];
    button.layer.borderWidth = 1.0;
    return button;
}

-(void)didButtonPressed:(UIButton*)button
{
    
    RelapSDKExampleArticleListViewController* vc = [RelapSDKExampleArticleListViewController new];
    vc.styleTag = button.tag;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
