//
//  SBUser.h
//  SlugBot
//
//  Created by lorabit on 05/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBUser : NSObject



+(instancetype)user;

@property(nonatomic,copy) NSString* deviceToken;
@property(nonatomic) NSInteger clientId;
@property(nonatomic) BOOL isDeviceTokenUploaded;
@property(nonatomic) NSInteger profileId;

@end
