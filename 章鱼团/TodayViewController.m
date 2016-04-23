//
//  TodayViewController.m
//  章鱼团
//
//  Created by 寿煜宇 on 16/4/19.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
{
    NSTimeInterval _startTime;
    NSTimeInterval _nowTime;
}
@property (nonatomic) NSURLSession *session;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) NSArray *activeTimeArray;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    self.listArray = [[NSArray alloc]init];
    [self setPreferredContentSize:CGSizeMake(0, 160)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}


//通过openURL的方式启动Containing APP
- (void)openURLContainingAPP
{
    [self.extensionContext openURL:[NSURL URLWithString:@"zhangyu://tuan"]
                 completionHandler:^(BOOL success) {
                     //NSLog(@"open url result:%d",success);
                 }];
}

- (IBAction)goZhangyu:(id)sender
{
    [self openURLContainingAPP];
    
}

#pragma mark - view
-(void)setListArray:(NSArray *)listArray
{
    _listArray = listArray;
    
    if (listArray.count == 3) {
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = (UIImageView *)[self.mainView viewWithTag:200+i];
            UILabel *shopNameLabel = (UILabel *)[self.mainView viewWithTag:210+i];
            UILabel *newPriceLabel = (UILabel *)[self.mainView viewWithTag:220+i];
            UILabel *oldPriceLabel = (UILabel *)[self.mainView viewWithTag:230+i];
            
            
            shopNameLabel.text = [listArray[i] objectForKey:@"brand"];
            newPriceLabel.text = [NSString stringWithFormat:@"￥%ld",[[listArray[i] objectForKey:@"current_price"] integerValue]/100];
            
            NSString *oldStr = [NSString stringWithFormat:@"%ld",[[listArray[i] objectForKey:@"market_price"] integerValue]/100];
            //中划线
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldStr attributes:attribtDic];
            oldPriceLabel.attributedText = attribtStr;
            //变换数据  网页
            
            NSString *imgStr = [listArray[i] objectForKey:@"na_logo"];
            NSRange range = [imgStr rangeOfString:@"src="];
            if (range.location != NSNotFound) {
                NSString *subStr = [imgStr substringFromIndex:range.location+range.length];
                subStr = [subStr stringByRemovingPercentEncoding];
                //[imageView sd_setImageWithURL:[NSURL URLWithString:subStr] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
            }
        }
       
    }else{
       
    }
    
}

#pragma mark - 时间

-(void)setActiveTimeArray:(NSArray *)activeTimeArray
{
    _activeTimeArray = activeTimeArray;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    _nowTime=[dat timeIntervalSince1970];
    //NSString *timeString = [NSString stringWithFormat:@"%.0f", _nowTime];
    //NSLog(@"=== %@",timeString);
    // NSLog(@"%@",activeTimeArray);
    for (int i = 0; i < activeTimeArray.count; i++)
    {
        NSInteger endtime = [[activeTimeArray[i] objectForKey:@"endtime"] integerValue];
        NSInteger starttime = [[activeTimeArray[i] objectForKey:@"starttime"] integerValue];
        if (_nowTime < endtime)
        {
            if (_nowTime < starttime)
            {
                self.label.text = @"距开始";
                _startTime = starttime;
            }else
            {
                self.label.text = @"距结束";
                _startTime = endtime;
            }
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];//定时器每秒传输
            break;
        }
    }
    
}

-(void)updateUI
{
    [self performSelectorOnMainThread:@selector(setTimeLabel) withObject:nil waitUntilDone:NO];//多线程
    //[self setTimeLabel];
}

-(void)setTimeLabel
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    _nowTime=[dat timeIntervalSince1970];
    if (_startTime <= _nowTime)
    {
        return;
    }
    NSInteger subTime = _startTime - _nowTime;
    NSInteger hour = subTime/3600;
    NSInteger min = (subTime%3600)/60;
    NSInteger sec = (subTime%3600)%60;
    self.hourLabel.text = [NSString stringWithFormat:@"%02ld",hour];
    self.minLabel.text = [NSString stringWithFormat:@"%02ld",min];
    self.secLabel.text = [NSString stringWithFormat:@"%02ld",sec];
    
}



@end
