//
//  AudioPlayerModule.h
//  SlugBot
//
//  Created by lorabit on 30/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SCModule.h"
#import "AudioPlayerModuleDelegate.h"

@interface AudioPlayerModule : SCModule

@property(nonatomic,readonly) BOOL isPlaying;
@property(nonatomic,readonly) float progress;
@property(nonatomic,readonly) float duration;
@property(nonatomic,readonly) float currentTime;
@property(nonatomic,weak) id<AudioPlayerModuleDelegate> delegate;

+(instancetype)module;
-(void)playUrl:(NSString*)url;
-(void)stop;

@end
