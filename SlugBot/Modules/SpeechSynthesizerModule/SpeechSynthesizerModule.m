//
//  SpeechSynthesizerModule.m
//  SlugBot
//
//  Created by lorabit on 09/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SpeechSynthesizerModule.h"
#import <iflyMSC/iflyMSC.h>
#import "PcmPlayer.h"


@interface SpeechSynthesizerModule()<
    IFlySpeechSynthesizerDelegate
>

@end

@implementation SpeechSynthesizerModule{
    PcmPlayer *audioPlayer;
    IFlySpeechSynthesizer * iFlySpeechSynthesizer;
}



+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[SpeechSynthesizerModule module] registerModule];
    });
}

+(instancetype)module{
    static SpeechSynthesizerModule* module;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        module = [SpeechSynthesizerModule new];
    });
    return module;
}

-(void)startWithText:(NSString *)text{
    if (audioPlayer != nil && audioPlayer.isPlaying == YES) {
        [audioPlayer stop];
    }
    if(iFlySpeechSynthesizer == nil){
        [self initSynthesizer];
    }
    
    [iFlySpeechSynthesizer startSpeaking:text];
}

-(void)stop{
    [iFlySpeechSynthesizer stopSpeaking];
}

- (void)initSynthesizer
{
    
    //合成服务单例
    if (iFlySpeechSynthesizer == nil) {
        iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    iFlySpeechSynthesizer.delegate = self;
    
    //设置语速1-100
    [iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    
    //设置音量1-100
    [iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [iFlySpeechSynthesizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置发音人
    
    //    云端支持发音人：小燕（xiaoyan）、小宇（xiaoyu）、凯瑟琳（Catherine）、
    //    亨利（henry）、玛丽（vimary）、小研（vixy）、小琪（vixq）、
    //    小峰（vixf）、小梅（vixm）、小莉（vixl）X、小蓉（四川话）、
    //    小芸（vixyun）、小坤（vixk）、小强（vixqa）、小莹（vixying）、 小新（vixx）、楠楠（vinn）老孙（vils）<br>
    //    对于网络TTS的发音人角色，不同引擎类型支持的发音人不同，使用中请注意选择。
    [iFlySpeechSynthesizer setParameter:@"vinn" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //设置文本编码格式
    [iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
}

-(void)onCompleted:(IFlySpeechError *)error{
    if(self.delegate){
        [self.delegate onSyncStop:error!=nil];
    }
}


@end
