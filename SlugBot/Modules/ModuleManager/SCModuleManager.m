//
//  SCModuleManager.m
//  SlugBot
//
//  Created by lorabit on 02/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SCModuleManager.h"
#import "SCModule.h"


@implementation SCModuleManager



+(instancetype)manager{
    static SCModuleManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SCModuleManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if(self = [super init]){
        self.registeredModules = [NSMutableArray new];
    }
    return self;
}

-(void)initializeModulesWithApplication:(UIApplication*)application options:(NSDictionary *)launchOptions{
    NSArray* sortedModules = [self.registeredModules sortedArrayUsingComparator:^NSComparisonResult(SCModule*  _Nonnull obj1, SCModule*  _Nonnull obj2) {
        NSNumber* p1 = @(obj1.priorityOfInitialization);
        NSNumber* p2 = @(obj2.priorityOfInitialization);
        return [p2 compare:p1];
    }];
    for(SCModule* module in sortedModules){
        [module initializeModuleWithApplication:application options:launchOptions];
    }
}


@end
