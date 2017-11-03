//
//  AppDelegate+RootView.m
//  SlugBot
//
//  Created by lorabit on 27/10/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "AppDelegate+RootView.h"
#import "ProfileListViewController.h"

@implementation AppDelegate (RootView)

+(void)load{
    swizzled_Method([self class], @selector(application:didFinishLaunchingWithOptions:), @selector(rootView_application:didFinishLaunchingWithOptions:));
}

- (BOOL)rootView_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self rootView_application:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:MainScreenBounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
    ProfileListViewController* profileListViewController = [[ProfileListViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:profileListViewController];
    self.window.rootViewController = nav;
    return YES;
}

@end
