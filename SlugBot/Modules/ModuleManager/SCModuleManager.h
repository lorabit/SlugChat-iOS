//
//  SCModuleManager.h
//  SlugBot
//
//  Created by lorabit on 02/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCModuleManager : NSObject

@property(atomic,strong) NSMutableArray* registeredModules;

+(instancetype)manager;

-(void)initializeModulesWithApplication:(UIApplication*)application options:(NSDictionary *)launchOptions;


@end
