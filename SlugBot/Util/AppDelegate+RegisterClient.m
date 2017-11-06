//
//  AppDelegate+RegisterClient.m
//  SlugBot
//
//  Created by lorabit on 05/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "AppDelegate+RegisterClient.h"
#import "MobileService.h"

@implementation AppDelegate(RegisterClient)

+(void)load{
    swizzled_Method([self class], @selector(application:didFinishLaunchingWithOptions:), @selector(registerClient_application:didFinishLaunchingWithOptions:));
}

- (BOOL)registerClient_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerClient_application:application didFinishLaunchingWithOptions:launchOptions];
    if([SBUser user].clientId > 0) {
        NSLog(@"Registered User: #%ld\n", [SBUser user].clientId);
        return YES;
    }
    SCRegisterClientRequest * request = [SCRegisterClientRequest new];
    request.platform = SCPlatform_Ios;
    [[MobileService service] registerClientWithRequest:request handler:^(SCRegisterClientResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Register Client: %@", error.localizedDescription);
        }else{
            [SBUser user].clientId = response.clientId;
        }
    }];
    return YES;
}
@end
