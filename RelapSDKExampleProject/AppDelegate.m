//
//  AppDelegate.m
//  RelapSDK
//
//  Created by Igor Kamenev on 21/01/15.
//  Copyright (c) 2015 Igor Kamenev. All rights reserved.
//

#import "AppDelegate.h"
#import "RelapSDKExampleSelectStyleViewController.h"
#import "RelapSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [RelapSDK setupWithApplicationID:@"RelapSDKExampleProject" userID:@"1"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    RelapSDKExampleSelectStyleViewController* vc = [RelapSDKExampleSelectStyleViewController new];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
