//
//  MobileService.m
//  SlugBot
//
//  Created by lorabit on 02/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "MobileService.h"
#import <GRPCClient/GRPCCall+Tests.h>

#ifdef DEBUG

//#define HOST @"10.0.0.213:50051"
#define HOST @"ec2-34-216-5-83.us-west-2.compute.amazonaws.com:50051"
//#define HOST @"slugchat.lorabit.com:50051"


#else

#define HOST @"slugchat.lorabit.com:50051"

#endif

@implementation MobileService{
    SCMobile * mobile;
}


+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[MobileService module] registerModule];
    });
}

+(instancetype)module{
    static MobileService* module;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        module = [MobileService new];
    });
    return module;
}

+(SCMobile*)service{
    return [MobileService module]->mobile;
}

-(void)initializeModuleWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions{
    [GRPCCall useInsecureConnectionsForHost:HOST];
    mobile = [[SCMobile alloc] initWithHost:HOST];
}


@end
