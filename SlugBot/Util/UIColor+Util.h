//
//  UIColor+Util.h
//  SlugBot
//
//  Created by lorabit on 04/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(Util)

+ (UIColor *)hexColorFloat:(NSString *)floatColorString;
+ (UIColor*) colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

@end
