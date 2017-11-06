//
//  AppDelegate+Notification.m
//  SlugBot
//
//  Created by lorabit on 05/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "AppDelegate+Notification.h"
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate(Notification)

+(void)load{
    swizzled_Method([self class], @selector(application:didFinishLaunchingWithOptions:), @selector(notification_application:didFinishLaunchingWithOptions:));
}

- (BOOL)notification_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self notification_application:application didFinishLaunchingWithOptions:launchOptions];
//    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if(granted){
//            [[UIApplication sharedApplication] registerForRemoteNotifications];
//        }
//    }];
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    [SBUser user].deviceToken = [deviceToken base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
