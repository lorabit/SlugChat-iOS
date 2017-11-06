//
//  ChatbotViewController.m
//  SlugBot
//
//  Created by lorabit on 05/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "ChatbotViewController.h"
#import "DialogflowModule.h"

@interface ChatbotViewController ()

@end

@implementation ChatbotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedStr(@"ChatbotTitle");
    self.view.backgroundColor = [UIColor whiteColor];
    AITextRequest * textRequest = [[DialogflowModule module] textRequest];
    textRequest.query = @"你好！";
    [textRequest setCompletionBlockSuccess:^(AIRequest *request, id response) {
        NSLog(@"%@\n", [response debugDescription]);
    } failure:^(AIRequest *request, NSError *error) {
        NSLog(@"%@\n", [error localizedDescription]);
    }];
    [[DialogflowModule module] enqueue:textRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
