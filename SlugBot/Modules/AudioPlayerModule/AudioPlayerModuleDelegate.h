//
//  AudioPlayerModuleDelegate.h
//  SlugBot
//
//  Created by lorabit on 30/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AudioPlayerModuleDelegate <NSObject>

@required
-(void)onStopPlayingAudio;

@end
