//
//  FY33TableViewCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/16.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMeishiTableViewCell.h"
#import "FYMenuBtnView.h"
#import "UIImageView+WebCache.h"

@implementation FYMeishiTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array //形成cell
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        for (int i = 0; i < array.count; i++)
        {
            NSDictionary *act = array[i];
            FYMenuBtnView *backView;
            
            if (array.count == 6)
            {
                if (i < 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame5:CGRectMake(i*[UIScreen mainScreen].bounds.size.width/2, 1, [UIScreen mainScreen].bounds.size.width/2-1, 79)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else{
                    backView = [[FYMenuBtnView alloc] initWithFrame3:CGRectMake((i-2)*[UIScreen mainScreen].bounds.size.width/4, 81, [UIScreen mainScreen].bounds.size.width/4-1, 119)
                                
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                    
                }
            } else if(array.count == 4)
            {
                if (i < 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame5:CGRectMake(i*[UIScreen mainScreen].bounds.size.width/2, 1, [UIScreen mainScreen].bounds.size.width/2-1, 79)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame5:CGRectMake((i-2)*[UIScreen mainScreen].bounds.size.width/2, 81, [UIScreen mainScreen].bounds.size.width/2-1, 79)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }
            } else if(array.count == 7)
            {
                if (i < 1)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame4:CGRectMake(0, 1, [UIScreen mainScreen].bounds.size.width/2 -1, 199)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else if (i <= 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame5:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100*(i-1)+1, [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }
                else{
                    backView = [[FYMenuBtnView alloc] initWithFrame3:CGRectMake((i-3)*[UIScreen mainScreen].bounds.size.width/4, 201, [UIScreen mainScreen].bounds.size.width/4-1, 119)
                                
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                }
            } else if(array.count == 8)
            {
                if (i < 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame5:CGRectMake(0, 100*i+1, [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else if (i <= 3)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame5:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100*(i-2)+1, [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }
                else{
                    backView = [[FYMenuBtnView alloc] initWithFrame3:CGRectMake((i-4)*[UIScreen mainScreen].bounds.size.width/4, 201, [UIScreen mainScreen].bounds.size.width/4-1, 119)
                                
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                }
            }
            else
            {
                if (i < 1)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame4:CGRectMake(0, 1, [UIScreen mainScreen].bounds.size.width/2 -1, 199)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else if (i <= 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame5:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100*(i-1)+1, [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }
                else{
                    backView = [[FYMenuBtnView alloc] initWithFrame5:CGRectMake((i-3)*[UIScreen mainScreen].bounds.size.width/2, 201, [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                }
                
            }
            
            backView.tag = 100+i;
            backView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBackView:)];
            [backView addGestureRecognizer:tap];
            
            backView.layer.borderWidth = 0.5;//边框线
            
            backView.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9].CGColor;
            backView.backgroundColor = [UIColor whiteColor];
            
            [self addSubview:backView];
            
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
    [self.delegate didSelectedHomeMeiAtIndex:tag];
}

@end
