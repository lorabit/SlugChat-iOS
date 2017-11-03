//
//  SCModule.h
//  SlugBot
//
//  Created by lorabit on 02/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCModule : NSObject

-(NSString*)moduleName;
-(int)priorityOfInitialization;
-(void)initializeModuleWithApplication:(UIApplication*)application options:(NSDictionary *)launchOptions;
-(void)registerModule;

@end
