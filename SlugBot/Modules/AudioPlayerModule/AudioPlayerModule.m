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
    AVAudioPlayer * audioPlayer;
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
        
    }
    return self;
}

-(void)playUrl:(NSString *)url{
    NSError * error;
//    playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:url]
                                                         error:&error];
    if(error){
        NSLog(@"%@", error.localizedDescription);
        if(self.delegate){
            [self.delegate onStopPlayingAudio];
        }
    }
    audioPlayer.delegate = self;
    if([audioPlayer prepareToPlay]){
        [audioPlayer play];
    }else{
        if(self.delegate){
            [self.delegate onStopPlayingAudio];
        }
    }
}

-(void)stop{
    [audioPlayer stop];
}

-(BOOL)isPlaying{
    if(!audioPlayer){
        return NO;
    }
    return audioPlayer.isPlaying;
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
    return audioPlayer.duration;
}

-(float)currentTime{
    if(!self.isPlaying){
        return 0;
    }
    return audioPlayer.currentTime;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if(self.delegate){
        [self.delegate onStopPlayingAudio];
    }
}


@end
