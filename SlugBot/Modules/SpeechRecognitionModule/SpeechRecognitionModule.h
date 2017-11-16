//
//  SpeechRecognitionModule.h
//  SlugBot
//
//  Created by lorabit on 06/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SCModule.h"
#import "SpeechRecognizerDelegate.h"

@interface SpeechRecognitionModule : SCModule


+(instancetype)module;
@property(nonatomic,readonly) BOOL isListening;
@property(nonatomic,weak) id<SpeechRecognizerDelegate> delegate;

-(void)start;
-(void)stop;

@end
