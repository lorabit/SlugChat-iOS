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

@interface ChatbotViewController ()<
    SpeechRecognizerDelegate,
SpeechSynthesizerDelegate
>

@end

@implementation ChatbotViewController{
    UIButton * btn;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedStr(@"ChatbotTitle");
    self.view.backgroundColor = [UIColor whiteColor];

    [[SpeechRecognitionModule module] setDelegate:self];
    [[SpeechSynthesizerModule module] setDelegate:self];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(hitBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@100);
    }];
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
    [btn setTitle:@"Listening..." forState:UIControlStateNormal];
}

-(void)onEndWithResult:(NSString *)text{
    NSLog(@"%@\n",text);
    [btn setTitle:text forState:UIControlStateNormal];
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
@end
