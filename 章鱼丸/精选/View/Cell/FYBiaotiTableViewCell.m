//
//  FYBiaotiTableViewCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYBiaotiTableViewCell.h"
#import "FYFuJinView.h"

@interface FYBiaotiTableViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer1;

@property (nonatomic, weak) UIView *daodianfu;
@property (nonatomic, weak) UILabel *titile1;
@property (nonatomic, weak) UILabel *titile2;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *subtitleLabel;
@property (nonatomic, weak) UILabel *tuijianLabel;

@end

@implementation FYBiaotiTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        NSDictionary *dao = _act[@"payAtshop"];
        UIView *daodianfu = [[UIView alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 35)];
        
        UILabel *titile1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
        UILabel *titile2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, [UIScreen mainScreen].bounds.size.width-120, 30)];
        
        titile1.font = [UIFont systemFontOfSize:12];
        titile1.text = dao[@"payText"];
        titile1.textAlignment = NSTextAlignmentLeft;
        titile1.textColor = [UIColor orangeColor];
        
        titile2.font = [UIFont systemFontOfSize:12];
        titile2.text = dao[@"title"];
        titile2.textAlignment = NSTextAlignmentLeft;
        titile2.textColor = [UIColor grayColor];
        
        [daodianfu addSubview:titile1];
        [daodianfu addSubview:titile2];
        [self.contentView addSubview:daodianfu];
        
        self.titile1 = titile1;
        self.titile2 = titile2;
        self.daodianfu = daodianfu;
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = _act[@"poi_name"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView  addSubview:titleLabel];
        self.titleLabel = titleLabel;
        //小标题
        
         UILabel *subtitleLabel = [[UILabel alloc] init];
         subtitleLabel.font = [UIFont systemFontOfSize:12];
         subtitleLabel.text = _act[@"poi_address"];
         subtitleLabel.textAlignment = NSTextAlignmentRight;
         subtitleLabel.textColor = [UIColor grayColor];
         [self.contentView  addSubview:subtitleLabel];
         self.subtitleLabel = subtitleLabel;
        
        
        //距离
        UILabel *tuijianLabel = [[UILabel alloc] init];
        tuijianLabel.font = [UIFont systemFontOfSize:12];
        
        float price = [_act[@"poi_distance"] floatValue]/1000;
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
        
        //触发效果1
        daodianfu.tag = 200;
        
        daodianfu.userInteractionEnabled = YES;//允许触发
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBackView:)];
        [daodianfu addGestureRecognizer:tap1];
        
        // 长按手势来形成按钮效果（按钮会和scrollView以及tableView的滑动冲突）
        self.pressRecognizer1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress1:)];//用长按来做出效果
        self.pressRecognizer1.minimumPressDuration = 0.05;
        self.pressRecognizer1.delegate = self;
        self.pressRecognizer1.cancelsTouchesInView = NO;
        
        [daodianfu addGestureRecognizer:self.pressRecognizer1];
        
        //触发效果  底层
        self.contentView.tag = 100;
        
        self.userInteractionEnabled = YES;//允许触发
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBackView:)];
        [self.contentView addGestureRecognizer:tap];
        
        // 长按手势来形成按钮效果（按钮会和scrollView以及tableView的滑动冲突）
        self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];//用长按来做出效果
        self.pressRecognizer.minimumPressDuration = 0.05;
        self.pressRecognizer.delegate = self;
        self.pressRecognizer.cancelsTouchesInView = NO;
        
        [self addGestureRecognizer:self.pressRecognizer];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
       }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //标题
    _titleLabel.frame = CGRectMake(10, 5, self.frame.size.width-20, 30);
    //小标题
    _subtitleLabel.frame = CGRectMake(self.frame.size.width-155, 40, 100, 20);
    //距离
    _tuijianLabel.frame = CGRectMake(self.frame.size.width-50, 40,50, 20);
    
}

- (void)setAct:(NSDictionary *)act
{
    _act = act;
    
    _titleLabel.text = _act[@"poi_name"];
    _subtitleLabel.text = _act[@"poi_address"];
    _tuijianLabel.text = _act[@"poi_distance"];

    if ([_act[@"payAtshop"] count] > 1)
    {
        _daodianfu.hidden = NO;
        NSDictionary *dao = _act[@"payAtshop"];
        _titile1.text = dao[@"payText"];
        _titile2.text = dao[@"title"];
    }else
    {
        _daodianfu.hidden = YES;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)OnTapBackView:(UITapGestureRecognizer *)sender//点击触发 手势
{
    UIView *backView = (UIView *)sender.view;
    int tag = (int)backView.tag+(int)self.nsn;
    [self.delegate didSelectedBiaotiAtIndex:tag];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == _pressRecognizer)
    {
        if (otherGestureRecognizer == _pressRecognizer1)
        {
            return NO;//防止两个长按串通----(两者都会询问)
        }else
        {
            return YES;
        }
        
    }else if (gestureRecognizer == _pressRecognizer1)
    {
        if (otherGestureRecognizer == _pressRecognizer)
        {
            return NO;//防止两个长按串通
        }else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
    
}

-(void)longPress:(UITapGestureRecognizer *)sender//长按触发
{
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
        self.daodianfu.backgroundColor= [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.daodianfu.backgroundColor= [UIColor whiteColor];
    }
    
}

-(void)longPress1:(UITapGestureRecognizer *)sender//长按触发
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
