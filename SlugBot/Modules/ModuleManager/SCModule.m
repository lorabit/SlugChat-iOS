//
//  SCModule.m
//  SlugBot
//
//  Created by lorabit on 02/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SCModule.h"
#import "SCModuleManager.h"

@implementation SCModule

-(NSString *)moduleName{
    return NSStringFromClass([self class]);
}

-(int)priorityOfInitialization{
    return 0;
}

-(void)initializeModuleWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions{
    
}

-(void)registerModule{
    [[SCModuleManager manager].registeredModules addObject:self];
}

@end
