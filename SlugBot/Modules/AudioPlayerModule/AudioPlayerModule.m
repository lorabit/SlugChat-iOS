//
//  AudioPlayerModule.m
//  SlugBot
//
//  Created by lorabit on 30/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "AudioPlayerModule.h"
#import <AVFoundation/AVFoundation.h>


@interface AudioPlayerModule()<
    AVAudioPlayerDelegate
>
@end

@implementation AudioPlayerModule{
    AVPlayer * player;
    AVPlayerItem * playerItem;
}

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AudioPlayerModule module] registerModule];
    });
}

+(instancetype)module{
    static AudioPlayerModule* module;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        module = [AudioPlayerModule new];
    });
    return module;
}

-(instancetype)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stop)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
    }
    return self;
}

-(void)playUrl:(NSString *)url{
    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    [player play];
}

-(void)stop{
    [player seekToTime:CMTimeMake(0, 1)];
    [player pause];
    if(self.delegate){
        [self.delegate onStopPlayingAudio];
    }
}

-(BOOL)isPlaying{
    if(!player){
        return NO;
    }
    return player.rate>0;
}

-(float)progress{
    if(!self.isPlaying){
        return 0;
    }
    return self.currentTime*100.0/self.duration;
}

-(float)duration{
    if(!self.isPlaying){
        return 0;
    }
    return CMTimeGetSeconds(playerItem.duration);
}

-(float)currentTime{
    if(!self.isPlaying){
        return 0;
    }
    return CMTimeGetSeconds(playerItem.currentTime);
}



@end
