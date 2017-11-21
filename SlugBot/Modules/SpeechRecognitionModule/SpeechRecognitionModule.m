//
//  SpeechRecognitionModule.m
//  SlugBot
//
//  Created by lorabit on 06/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "SpeechRecognitionModule.h"
#import <iflyMSC/iflyMSC.h>
#import "ISRDataHelper.h"

@interface SpeechRecognitionModule()<
    IFlySpeechRecognizerDelegate,
    IFlyPcmRecorderDelegate
>
@end

@implementation SpeechRecognitionModule{
    IFlySpeechRecognizer *iFlySpeechRecognizer;
    IFlyPcmRecorder *pcmRecorder;
    NSString* tmpResult;
    BOOL stopCallingDelegate;
}


+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[SpeechRecognitionModule module] registerModule];
    });
}

+(instancetype)module{
    static SpeechRecognitionModule* module;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        module = [SpeechRecognitionModule new];
    });
    return module;
}

-(void)initializeModuleWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions{
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
    }];
    
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_NONE];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",IFLY_APPID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

-(void)initRecognizer{
    if(iFlySpeechRecognizer != nil) return;
    iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    [iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    //设置听写模式
    [iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    iFlySpeechRecognizer.delegate = self;
    
    if (iFlySpeechRecognizer != nil) {
        
        //设置最长录音时间
        [iFlySpeechRecognizer setParameter:@"-1"  forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [iFlySpeechRecognizer setParameter:@"2000" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //设置语言
        [iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        
        //设置是否返回标点符号
        [iFlySpeechRecognizer setParameter:[IFlySpeechConstant ASR_PTT_HAVEDOT] forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
    
    //初始化录音器
    if (pcmRecorder == nil)
    {
        pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    
    pcmRecorder.delegate = self;
    
    [pcmRecorder setSample:@"16000"];
    
    [pcmRecorder setSaveAudioPath:nil];    //不保存录音文件
    
}

-(void)start{
    stopCallingDelegate = NO;
    [self initRecognizer];
    
    [iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_STREAM forKey:@"audio_source"];    //设置音频数据模式为音频流
    
    
    BOOL ret  = [iFlySpeechRecognizer startListening];
    
    if (ret) {
        //初始化录音环境
        [IFlyAudioSession initRecordingAudioSession];
        
        pcmRecorder.delegate = self;
        
        //启动录音器服务
        BOOL ret = [pcmRecorder start];
        NSLog(@"%s[OUT],Success,Recorder ret=%d",__func__,ret);
        if(!stopCallingDelegate && self.delegate){
            [self.delegate onStart];
        }
    }
    else
    {
        NSLog(@"%s[OUT],Failed",__func__);
    }
    tmpResult = @"";
}

-(void)stop{
    stopCallingDelegate = YES;
    [iFlySpeechRecognizer stopListening];
    [pcmRecorder stop];
}

-(BOOL)isListening{
    if(iFlySpeechRecognizer){
        return iFlySpeechRecognizer.isListening;
    }
    return NO;
}


#pragma mark - IFlySpeechRecognizerDelegate
-(void)onError:(IFlySpeechError *)errorCode{
    
}

-(void)onResults:(NSArray *)results isLast:(BOOL)isLast{
    if(results.count>0){
        NSMutableString *result = [[NSMutableString alloc] init];
        NSDictionary *dic = [results objectAtIndex:0];
        
        for (NSString *key in dic) {
            [result appendFormat:@"%@",key];
        }
        
        NSString * resultFromJson =  [ISRDataHelper stringFromJson:result];
        NSLog(@"%@\n",resultFromJson);
        tmpResult = [tmpResult stringByAppendingString:resultFromJson];
    }
    if(!stopCallingDelegate && self.delegate != nil && isLast){
        [self.delegate onEndWithResult:tmpResult];
    }
}

-(void)onEndOfSpeech{
    [pcmRecorder stop];
}


#pragma mark - IFlyPcmRecorderDelegate
-(void)onIFlyRecorderBuffer:(const void *)buffer bufferSize:(int)size{
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [iFlySpeechRecognizer writeAudio:audioBuffer];
//    if (!ret)
//    {
//        [iFlySpeechRecognizer stopListening];
//        [pcmRecorder stop];
//
//    }
}

-(void)onIFlyRecorderError:(IFlyPcmRecorder *)recoder theError:(int)error{
    
}


@end
