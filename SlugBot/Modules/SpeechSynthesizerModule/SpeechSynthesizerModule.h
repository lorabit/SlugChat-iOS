//
//  SpeechSynthesizerModule.h
//  SlugBot
//
//  Created by lorabit on 09/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SCModule.h"
#import "SpeechSynthesizerDelegate.h"

@interface SpeechSynthesizerModule : SCModule


@property(nonatomic,weak) id<SpeechSynthesizerDelegate> delegate;

+(instancetype)module;


-(void)startWithText:(NSString*)text;
-(void)stop;


@end
