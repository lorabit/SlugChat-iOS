//
//  DialogflowModule.h
//  SlugBot
//
//  Created by lorabit on 05/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SCModule.h"
#import <ApiAI.h>

@interface DialogflowModule : SCModule

+(instancetype)module;
@property(nonatomic,strong) ApiAI* apiAi;
-(void)enqueue:(AIRequest*) request;
-(AITextRequest*)textRequest;

@end
