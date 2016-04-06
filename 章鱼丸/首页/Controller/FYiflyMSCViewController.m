//
//  FYiflyMSCViewController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/18.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYiflyMSCViewController.h"
#import "FYData.h"
#import "FYDataModel.h"
#import "iflyMSC/IFlyMSC.h"
#import "IATConfig.h"

//包含头文件
//文字转语音
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

//语音转文字
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

#import "ISRDataHelper.h"

@interface FYiflyMSCViewController ()<IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate,IFlyRecognizerViewDelegate>
{
    //不带界面的识别对象
    IFlySpeechRecognizer *_iFlySpeechRecognizer;
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;
    IFlyRecognizerView *_iflyRecognizerView;//带界面的识别对象
}
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径

@property (weak, nonatomic) IBOutlet UILabel *label0;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *cankao;
@property (nonatomic) BOOL led;

@end

@implementation FYiflyMSCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cankao = [[NSMutableArray alloc] initWithObjects:@"甜蜜物", @"万达", @"按摩", @"美容", @"自助", @"写真", @"美甲", @"牛排", @"快餐", @"奥特曼", @"披萨", @"鸡排", @"银泰城", @"鲜花", @"奶茶", @"假面超人", @"宾馆", @"锦江之星", @"足浴", @"烘培", @"寿司", @"烧烤", @"甜品", @"甜蜜物", @"快餐", @"贡茶", @"牛排", nil];

    _textView.enabled = NO;//设置不能点击
    
    //demo录音文件保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];

    [self initIFly];
    
}

#pragma mark - 生成语音
//文字转语音
-(void)initIFly
{
        //1.创建合成对象
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        _iFlySpeechSynthesizer.delegate = self;
        //2.设置合成参数
        //设置在线工作方式
        [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                      forKey:[IFlySpeechConstant ENGINE_TYPE]];
        //音量,取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]]; //发音人,默认为”xiaoyan”,可以设置的参数列表可参考“合成发音人列表”
        [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey: [IFlySpeechConstant VOICE_NAME]]; //保存合成文件名,如不再需要,设置设置为nil或者为空表示取消,默认目录位于 library/cache下
        [_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
        //3.启动合成会话
        [_iFlySpeechSynthesizer startSpeaking: @"请大声说出您想要找什么"];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s",__func__);
    
    [super viewWillAppear:animated];
    
    [self initRecognizer];//初始化识别对象
    [self addTimer];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    NSLog(@"%s",__func__);
    
    if ([IATConfig sharedInstance].haveView == NO)
    {//无界面
        [_iFlySpeechRecognizer cancel]; //取消识别
        [_iFlySpeechRecognizer setDelegate:nil];
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    }
    else
    {
        [_iflyRecognizerView cancel]; //取消识别
        [_iflyRecognizerView setDelegate:nil];
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    }
    
    [super viewWillDisappear:animated];
    
    [_iFlySpeechRecognizer cancel];
    [self closeTimer];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)invoiceSearch:(id)sender//按下
{
    NSLog(@"按下");
    [self closeTimer];
    self.label1.text = @"";
    self.label2.text = @"";
    self.label3.text = @"";
    self.label4.text = @"";
    self.label5.text = @"";
    [_iFlySpeechSynthesizer stopSpeaking];
    
    NSLog(@"%s[IN]",__func__);
    
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        
        [_textView setText:@""];
        [_textView resignFirstResponder];
        self.isCanceled = NO;
        
        if(_iFlySpeechRecognizer == nil)
        {
            [self initRecognizer];
        }
        
        [_iFlySpeechRecognizer cancel];
        
        //设置音频来源为麦克风
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        [_iFlySpeechRecognizer setDelegate:self];
        
        BOOL ret = [_iFlySpeechRecognizer startListening];
        
        if (ret) {
            
        }else{
        }
    }else {
        
        if(_iflyRecognizerView == nil)
        {
            [self initRecognizer ];
        }
        
        [_textView setText:@""];
        [_textView resignFirstResponder];
        
        //设置音频来源为麦克风
        [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //设置听写结果格式为json
        [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
        [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        [_iflyRecognizerView start];
    }

}

- (IBAction)outvoiceSearch:(id)sender//放开
{
    NSLog(@"放开");
    self.label0.text = @"";
    [_iFlySpeechRecognizer stopListening];
    [_textView resignFirstResponder];
    
    if ([_textView.text length] > 0 )
    {
        FYData *item = [[FYDataModel sharedStore] allItems][0];
        item.searchTerm = _textView.text;
        
        NSMutableArray *history = [[NSMutableArray alloc] init];
        [history addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:item.historyData]];
        [history insertObject:_textView.text atIndex:0];//插入一个对象
        //[self.history addObject:searchTerm];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:history];
        item.historyData = data;
       
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (IBAction)esc:(id)sender//离开
{
    [_iFlySpeechSynthesizer stopSpeaking];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - timer方法
/**
 *  添加定时器
 */
-(void)addTimer
{
    self.led = YES;
    unsigned long i = random()%(self.cankao.count - 5);
    //NSLog(@"%ld",i);
    self.label1.text = self.cankao[i+0];
    self.label2.text = self.cankao[i+1];
    self.label3.text = self.cankao[i+2];
    self.label4.text = self.cankao[i+3];
    self.label5.text = self.cankao[i+4];
    
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    //多线程 UI IOS程序默认只有一个主线程，处理UI的只有主线程。如果拖动第二个UI，则第一个UI事件则会失效。
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


-(void)nextImage
{
    if (self.led == YES)
    {
        [UIView animateWithDuration:3.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.label1.alpha = 0.0;
                             self.label2.alpha = 0.0;
                             self.label3.alpha = 0.0;
                             self.label4.alpha = 0.0;
                             self.label5.alpha = 0.0;
                             self.led = NO;
                         }completion:^(BOOL com){
                             unsigned long i = random()%(self.cankao.count - 5);
                             //NSLog(@"%ld",i);
                             self.label1.text = self.cankao[i+0];
                             self.label2.text = self.cankao[i+1];
                             self.label3.text = self.cankao[i+2];
                             self.label4.text = self.cankao[i+3];
                             self.label5.text = self.cankao[i+4];
                         }];//结束后调用，换字符

    }else
    {
        
        [UIView animateWithDuration:2.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.label1.alpha = 1.0;
                             self.label2.alpha = 1.0;
                             self.label3.alpha = 1.0;
                             self.label4.alpha = 1.0;
                             self.label5.alpha = 1.0;
                             self.led = YES;
                         }completion:NULL];
    }
    
}



/**
 *  关闭定时器
 */
-(void)closeTimer
{
    [self.timer invalidate];
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
    if (self.isCanceled)
    {
        return;
    }
    
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    
    self.label0.text = @"";
    
    
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"%s",__func__);
    
    if (error.errorCode)
    {
        self.label0.text = @"抱歉没听清";
    }
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@%@", _textView.text,resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _textView.text = [NSString stringWithFormat:@"%@%@", _textView.text,resultFromJson];

    if ([_textView.text length] == 0 )
    {
        self.label0.text = @"抱歉没听清";
    }
    
    /*
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,_textView.text);
     */
}



/**
 有界面，听写结果回调
 resultArray：听写结果
 isLast：表示最后一次
 ****/
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,result];
    
}



/**
 听写取消回调
 ****/
- (void) onCancel
{
    NSLog(@"识别取消");
}

-(void) showPopup
{
}

#pragma mark - IFlyDataUploaderDelegate

/**
 上传联系人和词表的结果回调
 error ，错误码
 ****/
- (void) onUploadFinished:(IFlySpeechError *)error
{
    NSLog(@"%d",[error errorCode]);
    
    if ([error errorCode] == 0) {
        
    }
    else {
        
        
    }
    
}




/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    NSLog(@"%s",__func__);
    
    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        
        //单例模式，无UI的实例
        if (_iFlySpeechRecognizer == nil) {
            _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
            
            [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
            [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        }
        _iFlySpeechRecognizer.delegate = self;
        
        if (_iFlySpeechRecognizer != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            
            //设置最长录音时间
            [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //设置采样率，推荐使用16K
            [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            
            if ([instance.language isEqualToString:[IATConfig chinese]]) {
                //设置语言
                [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
                //设置方言
                [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            }else if ([instance.language isEqualToString:[IATConfig english]]) {
                [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            }
            //设置是否返回标点符号
            [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
    }else  {//有界面
        
        //单例模式，UI的实例
        if (_iflyRecognizerView == nil) {
            //UI显示剧中
            _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
            
            [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
            [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
            
        }
        _iflyRecognizerView.delegate = self;
        
        if (_iflyRecognizerView != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            //设置最长录音时间
            [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //设置采样率，推荐使用16K
            [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            if ([instance.language isEqualToString:[IATConfig chinese]]) {
                //设置语言
                [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
                //设置方言
                [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            }else if ([instance.language isEqualToString:[IATConfig english]]) {
                //设置语言
                [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            }
            //设置是否返回标点符号
            [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
    }
}

@end
