//
//  RelapSDKExampleArticleViewController.h
//  RelapSDK
//
//  Created by Igor Kamenev on 22/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelapSDKExampleArticleViewController : UIViewController

@property (nonatomic) NSInteger styleTag;

-(instancetype)initWithDict: (NSDictionary*) dict;

@end
