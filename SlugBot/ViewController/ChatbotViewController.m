//
//  ChatbotViewController.m
//  SlugBot
//
//  Created by lorabit on 05/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "ChatbotViewController.h"
#import "DialogflowModule.h"
#import "SpeechRecognitionModule.h"
#import "SpeechSynthesizerModule.h"
#import "MobileService.h"
#import "EmotionModule.h"

@interface ChatbotViewController ()<
    SpeechRecognizerDelegate,
    SpeechSynthesizerDelegate,
EmotionDelegate
>

@end

@implementation ChatbotViewController{
    UIButton * btn;
    UIImageView* emotionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ - %@",LocalizedStr(@"ChatbotTitle"),[SBUser user].profileName];
    self.view.backgroundColor = [UIColor whiteColor];

    emotionView = [UIImageView new];
    [self.view addSubview:emotionView];
    
    [emotionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    
    [[SpeechRecognitionModule module] setDelegate:self];
    [[SpeechSynthesizerModule module] setDelegate:self];
    [[EmotionModule module] setDelegate:self];
    [[EmotionModule module] setEmotion:SCChatbotResponse_Emotion_Normal];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(hitBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(emotionView);
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

-(void)hitBtn{
    [[SpeechSynthesizerModule module] stop];
    [[SpeechRecognitionModule module] start];
    NSLog(@"Start ...\n");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onStart{
//    [btn setTitle:@"Listening..." forState:UIControlStateNormal];
    
    [[EmotionModule module] setEmotion:SCChatbotResponse_Emotion_Listening];
}

-(void)onEndWithResult:(NSString *)text{
//    NSLog(@"%@\n",text);
//    [btn setTitle:text forState:UIControlStateNormal];
    [self interactWithMobileService:text];
}

-(void)interactWithMobileService:(NSString*) text{
    SCUserRequest * userRequest = [SCUserRequest new];
    [userRequest setProfileId:[SBUser user].profileId];
    [userRequest setText:text];
    [[MobileService service] getChatbotResponseWithRequest:userRequest
                                                   handler:^(SCChatbotResponse * _Nullable response, NSError * _Nullable error) {
                                                       if(error){
                                                           NSLog(@"%@\n", [error localizedDescription]);
                                                           [[SpeechRecognitionModule module] start];
                                                           return;
                                                       }
                                                       [[SpeechSynthesizerModule module] startWithText:response.text];
                                                       [[EmotionModule module] setEmotion:response.emotion];
                                                   }];
}

-(void)interactWithDialogflow:(NSString*) text{
    AITextRequest * textRequest = [[DialogflowModule module] textRequest];
    textRequest.query = text;
    [textRequest setCompletionBlockSuccess:^(AIRequest *request, id response) {
        [[SpeechSynthesizerModule module] startWithText:response[@"result"][@"fulfillment"][@"speech"]];
        NSLog(@"%@\n", [response debugDescription]);
    } failure:^(AIRequest *request, NSError *error) {
        NSLog(@"%@\n", [error localizedDescription]);
        [[SpeechRecognitionModule module] start];
    }];
    [[DialogflowModule module] enqueue:textRequest];
}

-(void)onSyncStop:(BOOL)hasError{
    [[SpeechRecognitionModule module] start];
}

-(void)onUpdateEmotionImage:(UIImage *)image{
    [emotionView setImage:image];
}
@end
