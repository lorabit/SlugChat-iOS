//
//  SpeechRecognizerDelegate.h
//  SlugBot
//
//  Created by lorabit on 06/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SpeechRecognizerDelegate <NSObject>

-(void)onStart;
-(void)onEndWithResult:(NSString*) text;

@end
