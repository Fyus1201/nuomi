//
//  FYBiaotiTableViewCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYJBiaotiTableViewCell.h"
#import "FYFuJinView.h"

@interface FYJBiaotiTableViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *subtitleLabel;
@property (nonatomic, weak) UILabel *tuijianLabel;

@end

@implementation FYJBiaotiTableViewCell
/*
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
     // NSLog(@"cellForRowAtIndexPath");
     static NSString *identifier = @"status";
    // 1.缓存中取
    FYJBiaotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
     // 2.创建
   if (cell == nil) {
        cell = [[FYJBiaotiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
 }*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = _act[@"shop_name"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView  addSubview:titleLabel];
        self.titleLabel = titleLabel;
        //小标题
        /*
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = _act[@"poi_address"];
        subtitleLabel.textAlignment = NSTextAlignmentRight;
        subtitleLabel.textColor = [UIColor grayColor];
        [self.contentView  addSubview:subtitleLabel];
        self.subtitleLabel = subtitleLabel;
        */
        
        //距离
        UILabel *tuijianLabel = [[UILabel alloc] init];
        tuijianLabel.font = [UIFont systemFontOfSize:12];
        
        float price = [_act[@"distance"] floatValue]/1000;
        if (price < 1)
        {
            tuijianLabel.text = [NSString stringWithFormat:@"<1km"];
        }else
        {
            if ((int)price == price)
            {
                tuijianLabel.text = [NSString stringWithFormat:@"%dkm",(int)price];
            }else
            {
                tuijianLabel.text = [NSString stringWithFormat:@"%.1fkm",price];
            }
        }
        
        tuijianLabel.textAlignment = NSTextAlignmentCenter;
        tuijianLabel.textColor = [UIColor grayColor];
        [self.contentView  addSubview:tuijianLabel];
        _tuijianLabel = tuijianLabel;
        
        //其他
        UILabel *tuijianLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35,100, 20)];
        tuijianLabel1.font = [UIFont systemFontOfSize:14];
        tuijianLabel1.text = @"暂无评价";
        tuijianLabel1.textAlignment = NSTextAlignmentLeft;
        tuijianLabel1.textColor = [UIColor grayColor];
        [self.contentView addSubview:tuijianLabel1];

        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //标题
    _titleLabel.frame = CGRectMake(10, 5, self.frame.size.width-20, 30);
    //小标题
    //self.subtitleLabel.frame = CGRectMake(self.frame.size.width-155, 40, 100, 20);
    //距离
    _tuijianLabel.frame = CGRectMake(self.frame.size.width-50, 40,50, 20);
    
}

- (void)setAct:(NSDictionary *)act
{
    _act = act;
    
    _titleLabel.text = _act[@"shop_name"];
    //_subtitleLabel.text = _act[@"poi_address"];
    
    float price = [_act[@"distance"] floatValue]/1000;
    if (price < 1)
    {
        _tuijianLabel.text = [NSString stringWithFormat:@"<1km"];
    }else
    {
        if ((int)price == price)
        {
            _tuijianLabel.text = [NSString stringWithFormat:@"%dkm",(int)price];
        }else
        {
            _tuijianLabel.text = [NSString stringWithFormat:@"%.1fkm",price];
        }
    }
    
    self.userInteractionEnabled = YES;//允许触发
    
    /* 长按手势来形成按钮效果（按钮会和scrollView以及tableView的滑动冲突） */
    self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];//用长按来做出效果
    self.pressRecognizer.minimumPressDuration = 0.05;
    self.pressRecognizer.delegate = self;
    self.pressRecognizer.cancelsTouchesInView = NO;
    
    [self addGestureRecognizer:self.pressRecognizer];
    
    
    //backView.backgroundColor = [UIColor whiteColor];
    //[self addSubview:backView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)OnTapBackView:(UITapGestureRecognizer *)sender//点击触发 手势
{
    UIView *backView = (UIView *)sender.view;
    int tag = (int)backView.tag-100;
    [self.delegate didSelectedJBiaotiAtIndex:tag];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;//长按手势会独占对象，故用代理将他取消独占
}

-(void)longPress:(UITapGestureRecognizer *)sender//长按触发
{
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        sender.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        sender.view.backgroundColor = [UIColor whiteColor];
    }
    
}

@end
