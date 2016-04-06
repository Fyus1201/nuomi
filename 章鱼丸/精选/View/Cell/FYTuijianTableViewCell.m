//
//  FYTuijianTableViewCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYTuijianTableViewCell.h"
#import "FYFuJinView.h"

@interface FYTuijianTableViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer;

@end

@implementation FYTuijianTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array //形成cell
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        UILabel *titile = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-50, 30)];
        titile.text = @"购物商场";
        top.backgroundColor = [UIColor whiteColor];
        [top addSubview:titile];
        
        for (int i = 0; i < array.count; i++)
        {
            NSDictionary *act = array[i];
            
            FYFuJinView *backView = [[FYFuJinView alloc] initWithFrame0:CGRectMake(i*[UIScreen mainScreen].bounds.size.width/3, 30, [UIScreen mainScreen].bounds.size.width/3, 170)
                                                    name:act[@"name"]
                                                       distance:act[@"distance"]
                                                     discount:act[@"discount"]
                                                    imagestr:act[@"imgUrl"]
                                                       array:act[@"recReason"]];
            
            backView.tag = 100+i;
            
            backView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBackView:)];
            [backView addGestureRecognizer:tap];

            /* 长按手势来形成按钮效果（按钮会和scrollView以及tableView的滑动冲突） */
            self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];//用长按来做出效果
            self.pressRecognizer.minimumPressDuration = 0.05;
            self.pressRecognizer.delegate = self;
            self.pressRecognizer.cancelsTouchesInView = NO;
            
            [backView addGestureRecognizer:self.pressRecognizer];
            
            backView.backgroundColor = [UIColor whiteColor];
            [self addSubview:backView];
            [self addSubview:top];
            
        }
    }
    return self;
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
    [self.delegate didSelectedTuiJianAtIndex:tag];
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
