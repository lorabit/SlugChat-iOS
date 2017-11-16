//
//  EmotionDelegate.h
//  SlugBot
//
//  Created by lorabit on 15/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EmotionDelegate <NSObject>

@required
-(void)onUpdateEmotionImage:(UIImage*) image;

@end
