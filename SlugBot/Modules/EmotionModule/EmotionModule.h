//
//  EmotionModule.h
//  SlugBot
//
//  Created by lorabit on 15/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SCModule.h"
#import <SCMobile/Mobile.pbrpc.h>
#import "EmotionDelegate.h"

@interface EmotionModule : SCModule

@property(nonatomic) SCChatbotResponse_Emotion emotion;
@property(nonatomic,weak) id<EmotionDelegate> delegate;

+(instancetype)module;



@end
