//
//  EmotionModule.m
//  SlugBot
//
//  Created by lorabit on 15/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "EmotionModule.h"

#define ROUND_CHECK_INTERVAL 10
#define IDLE_INTERVAL 100

@implementation EmotionModule{
    double last_update;
    SCChatbotResponse_Emotion current_emotion;
    NSDictionary<NSNumber*, NSArray<NSString*>*>* emotion_images;
}


+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[EmotionModule module] registerModule];
    });
}

+(instancetype)module{
    static EmotionModule* module;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        module = [EmotionModule new];
    });
    return module;
}

-(instancetype)init{
    self = [super init];
    if(self){
        
        emotion_images = @{
                           @(SCChatbotResponse_Emotion_Sleep):@[@"idle"],
                           @(SCChatbotResponse_Emotion_Normal):@[@"normal"],
                           @(SCChatbotResponse_Emotion_Listening):@[@"listening"],
                           @(SCChatbotResponse_Emotion_Sad):@[@"sad"],
                           @(SCChatbotResponse_Emotion_Happy):@[@"happy"],
        };
    }
    return self;
}

-(void)setDelegate:(id<EmotionDelegate>)delegate{
    _delegate = delegate;
    _emotion = SCChatbotResponse_Emotion_Sleep;
}

-(void)setEmotion:(SCChatbotResponse_Emotion)emotion{
    _emotion = emotion;
    [self updateEmtion];
}

-(void)updateEmtion{
    current_emotion = _emotion;
    last_update = [NSDate dateWithTimeIntervalSinceNow:0].timeIntervalSince1970;
    if(self.delegate){
        [self.delegate onUpdateEmotionImage:[UIImage imageNamed:[emotion_images[@(_emotion)] firstObject]]];
    }
}


@end
