//
//  MobileService.h
//  SlugBot
//
//  Created by lorabit on 02/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SCModule.h"
#import <SCMobile/Mobile.pbrpc.h>

@interface MobileService : SCModule

//@property(nonatomic,strong) SCMobile * mobile;

+(SCMobile*)service;
+(instancetype)module;


@end
