//
//  ChatbotViewController.m
//  SlugBot
//
//  Created by lorabit on 05/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "ChatbotViewController.h"
//#import "DialogflowModule.h"
#import "SpeechRecognitionModule.h"
#import "SpeechSynthesizerModule.h"
#import "MobileService.h"
#import "EmotionModule.h"
#import "AudioPlayerModule.h"


@interface ChatbotViewController ()<
SpeechRecognizerDelegate,
SpeechSynthesizerDelegate,
EmotionDelegate,
AudioPlayerModuleDelegate
>

@end

@implementation ChatbotViewController{
    UIButton * btn;
    UIImageView* emotionView;
    BOOL isExiting;
    NSDate* lastSpeechTime;
    SCChatbotResponse * playingResponse;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isExiting = NO;
    self.title = [NSString stringWithFormat:@"%@ - %@",LocalizedStr(@"ChatbotTitle"),[SBUser user].profileName];
    self.view.backgroundColor = [UIColor whiteColor];
    
    emotionView = [UIImageView new];
    [self.view addSubview:emotionView];
    
    [emotionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    
    [[SpeechRecognitionModule module] setDelegate:self];
    [[SpeechSynthesizerModule module] setDelegate:self];
    [[AudioPlayerModule module] setDelegate:self];
    [[EmotionModule module] setDelegate:self];
    [[EmotionModule module] setEmotion:SCChatbotResponse_Emotion_Sleep];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(hitBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(emotionView);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(exit)
                                                 name:ExisitingAppNotificationName
                                               object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self exit];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ExisitingAppNotificationName
                                                  object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self interactWithMobileService:@"$start"];
}

-(void)generateStopLog{
    if(playingResponse == nil){
        return;
    }
    SCLog* log = [SCLog new];
    log.profileId = [SBUser user].profileId;
    if(playingResponse.responseType == SCChatbotResponse_ResponseType_Audio){
        if([AudioPlayerModule module].isPlaying){
            log.logType = SCLog_LogType_InterruptAudio;
            log.content = [NSString stringWithFormat:@"%.2f,%.2f,%.2f,%lld",
                           [AudioPlayerModule module].progress,
                           [AudioPlayerModule module].currentTime,
                           [AudioPlayerModule module].duration,
                           playingResponse.logId];
        }
    }else{
        if([SpeechSynthesizerModule module].endPos>0){
            log.logType = SCLog_LogType_InterruptSpeech;
            log.content = [NSString stringWithFormat:@"%d,%d,%d,%lld",[SpeechSynthesizerModule module].progress,[SpeechSynthesizerModule module].beginPos,[SpeechSynthesizerModule module].endPos,playingResponse.logId];
        }
    }
    if(log.content!=NULL && log.content.length>0){
        [[MobileService service] createLogWithRequest:log
                                              handler:^(SCLog * _Nullable response, NSError * _Nullable error) {
                                                  if(error){
                                                      NSLog(@"%@",error.localizedDescription);
                                                  }
                                              }];
    }
}

-(void)exit{
    [self generateStopLog];
    isExiting = YES;
    [[AudioPlayerModule module] stop];
    [[SpeechRecognitionModule module] stop];
    [[SpeechSynthesizerModule module] stop];
}

-(void)hitBtn{
    if([AudioPlayerModule module].isPlaying){
        [self generateStopLog];
        [[AudioPlayerModule module] stop];
        return;
    }
    if([SpeechRecognitionModule module].isListening){
        [[SpeechRecognitionModule module] stop];
        [self interactWithMobileService:@"$hit"];
        return;
    }
    
    if([SpeechSynthesizerModule module].endPos>0 && [SpeechSynthesizerModule module].beginPos<20){
        return;
    }
    
    
    [self generateStopLog];
    
    [[SpeechSynthesizerModule module] stop];
    [[SpeechRecognitionModule module] start];
    
  
    
}

-(void)playResponse:(SCChatbotResponse*) response{
    playingResponse = response;
    [[EmotionModule module] setEmotion:response.emotion];
    switch (response.responseType) {
        case SCChatbotResponse_ResponseType_Audio:
            [[AudioPlayerModule module] playUrl:response.text];
            break;
        default:
            [[SpeechSynthesizerModule module] startWithText:response.text];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onStart{
    //    [btn setTitle:@"Listening..." forState:UIControlStateNormal];
    playingResponse = nil;
    [[EmotionModule module] setEmotion:SCChatbotResponse_Emotion_Listening];
}

-(void)onEndWithResult:(NSString *)text{
    if(isExiting) {
        return;
    }
    //    NSLog(@"%@\n",text);
    //    [btn setTitle:text forState:UIControlStateNormal];
    if(text.length == 0){
        [self noSpeech];
        return;
    }
    [self interactWithMobileService:text];
}

-(void)noSpeech{
    if(lastSpeechTime!=nil && [NSDate date].timeIntervalSince1970 - lastSpeechTime.timeIntervalSince1970 > 30){
        [self interactWithMobileService:@"$noSpeech{30}"];
    }else{
        [self interactWithMobileService:@""];
    }
}

-(void)interactWithMobileService:(NSString*) text{
    if(isExiting) {
        return;
    }
    if([text length] == 0){
        [[SpeechRecognitionModule module] start];
        return;
    }
    lastSpeechTime = [NSDate date];
    btn.enabled = NO;
    SCUserRequest * userRequest = [SCUserRequest new];
    [userRequest setProfileId:[SBUser user].profileId];
    [userRequest setText:text];
    SCMetaData * metaData = [SCMetaData new];
    metaData.version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [userRequest setMetaData:metaData];
    
#ifdef DEBUG
    NSDate * startDate = [NSDate date];
#endif
    [[MobileService service] getChatbotResponseWithRequest:userRequest
                                                   handler:^(SCChatbotResponse * _Nullable response, NSError * _Nullable error) {
#ifdef DEBUG
                                                       NSLog(@"Response time: %.4f s\n", [NSDate date].timeIntervalSince1970 - startDate.timeIntervalSince1970);
#endif
                                                       if(isExiting) {
                                                           return;
                                                       }
                                                       btn.enabled = YES;
                                                       if(error){
                                                           NSLog(@"%@\n", [error localizedDescription]);
                                                           [[SpeechRecognitionModule module] start];
                                                           return;
                                                       }
                                                       [self playResponse:response];
                                                   }];
}

//-(void)interactWithDialogflow:(NSString*) text{
//    AITextRequest * textRequest = [[DialogflowModule module] textRequest];
//    textRequest.query = text;
//    [textRequest setCompletionBlockSuccess:^(AIRequest *request, id response) {
//        [[SpeechSynthesizerModule module] startWithText:response[@"result"][@"fulfillment"][@"speech"]];
//        NSLog(@"%@\n", [response debugDescription]);
//    } failure:^(AIRequest *request, NSError *error) {
//        NSLog(@"%@\n", [error localizedDescription]);
//        [[SpeechRecognitionModule module] start];
//    }];
//    [[DialogflowModule module] enqueue:textRequest];
//}

-(void)onSyncStop:(BOOL)hasError{
    if(isExiting) {
        return;
    }
    [[SpeechRecognitionModule module] start];
}

-(void)onStopPlayingAudio{
    if(isExiting) {
        return;
    }
    [[SpeechRecognitionModule module] start];
}

-(void)onUpdateEmotionImage:(UIImage *)image{
    [emotionView setImage:image];
}
@end

