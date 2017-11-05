//
//  Header.h
//  SlugBot
//
//  Created by lorabit on 27/10/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import <objc/runtime.h>
#import "SBTool.h"

#import "Masonry.h"


#import "UIColor+Util.h"


#define MainScreenBounds    [UIScreen mainScreen].bounds
#define WS(wSelf)           __weak typeof(self) wSelf = self
#define SS(sSelf)           __strong typeof(wSelf) sSelf = wSelf
#define NOTICENTER          [NSNotificationCenter defaultCenter]
#define USERDEFAULT         [NSUserDefaults standardUserDefaults]
#define LocalizedStr(key)   NSLocalizedString(key, @"")

#define BACKGROUNDCOLOR_AVATAR [UIColor colorWithWhite:0 alpha:0.02];

#endif /* Header_h */
