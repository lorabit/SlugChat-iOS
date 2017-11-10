//
//  SpeechSynthesizerDelegate.h
//  SlugBot
//
//  Created by lorabit on 10/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SpeechSynthesizerDelegate <NSObject>

@required
-(void)onSyncStop:(BOOL)hasError;

@end
