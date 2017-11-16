//
//  DialogflowModule.m
//  SlugBot
//
//  Created by lorabit on 05/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "DialogflowModule.h"


@implementation DialogflowModule
//
//+(void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[DialogflowModule module] registerModule];
//    });
//}
//
//+(instancetype)module{
//    static DialogflowModule* module;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        module = [DialogflowModule new];
//    });
//    return module;
//}
//
//-(instancetype)init{
//    self = [super init];
//    if(self){
//        _apiAi = [[ApiAI alloc] init];
//        id<AIConfiguration> config = [AIDefaultConfiguration new];
//        config.clientAccessToken = DIALOGFLOW_TOKEN;
//        _apiAi.configuration = config;
//    }
//    return self;
//}
//
//-(void)enqueue:(AIRequest *)request{
//    [_apiAi enqueue:request];
//}
//
//-(AITextRequest *)textRequest{
//    AITextRequest* request = [_apiAi textRequest];
//    request.sessionId = [NSString stringWithFormat:@"%ld", [SBUser user].profileId];
//    return request;
//}






@end
