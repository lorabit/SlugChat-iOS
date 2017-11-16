//
//  SBUser.m
//  SlugBot
//
//  Created by lorabit on 05/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SBUser.h"

@implementation SBUser

+(instancetype)user{
    static SBUser* user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [SBUser new];
    });
    return user;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        if([USERDEFAULT objectForKey:@"clientId"]){
            _clientId = [[USERDEFAULT objectForKey:@"clientId"] integerValue];
        }else{
            _clientId = 0;
        }
        if([USERDEFAULT objectForKey:@"profileId"]){
            _profileId = [[USERDEFAULT objectForKey:@"profileId"] integerValue];
        }else{
            _profileId = 0;
        }
        _deviceToken =[USERDEFAULT objectForKey:@"deviceToken"];
        _profileName =[USERDEFAULT objectForKey:@"profileName"];
        if([USERDEFAULT objectForKey:@"isDeviceTokenUploaded"]){
            _isDeviceTokenUploaded = [[USERDEFAULT objectForKey:@"isDeviceTokenUploaded"] boolValue];
        }else{
            _isDeviceTokenUploaded = NO;
        }
    }
    return self;
}

-(void)setClientId:(NSInteger)clientId{
    _clientId = clientId;
    [USERDEFAULT setObject:@(clientId) forKey:@"clientId"];
}

-(void)setDeviceToken:(NSString *)deviceToken{
    if([_deviceToken isEqualToString:deviceToken]){
        return;
    }
    _deviceToken = deviceToken;
    [USERDEFAULT setObject:deviceToken forKey:@"deviceToken"];
    [self setIsDeviceTokenUploaded:NO];
}


-(void)setProfileName:(NSString *)profileName{
    if([_profileName isEqualToString:profileName]){
        return;
    }
    _profileName = profileName;
    [USERDEFAULT setObject:profileName forKey:@"profileName"];
}

-(void)setIsDeviceTokenUploaded:(BOOL)isDeviceTokenUploaded{
    _isDeviceTokenUploaded = isDeviceTokenUploaded;
    [USERDEFAULT setObject:@(isDeviceTokenUploaded) forKey:@"isDeviceTokenUploaded"];
}

-(void)setProfileId:(NSInteger)profileId{
    _profileId = profileId;
    [USERDEFAULT setObject:@(profileId) forKey:@"profileId"];
}






@end
