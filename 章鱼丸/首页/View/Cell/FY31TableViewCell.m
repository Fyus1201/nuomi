//
//  FY31TableViewCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/14.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FY31TableViewCell.h"
#import "FYHomeGroupModel.h"
#import "FYMenuBtnView.h"
#import "UIImageView+WebCache.h"

@implementation FY31TableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array//形成cell
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        for (int i = 0; i < array.count; i++)
        {
            NSLog(@"%d",i);
            NSDictionary *act = array[i];
            FYMenuBtnView *backView;
            if (array.count == 6)
            {
                backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2-1, 79)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                
            }
            else if (array.count == 6)
            {
                if (i < 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake(i*[UIScreen mainScreen].bounds.size.width/2, 1, [UIScreen mainScreen].bounds.size.width/2-1, 79)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else{
                    backView = [[FYMenuBtnView alloc] initWithFrame6:CGRectMake((i-2)*[UIScreen mainScreen].bounds.size.width/4, 81, [UIScreen mainScreen].bounds.size.width/4-1, 118)
                                
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                    
                }
            } else if(array.count == 4)
            {
                if (i < 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake(i*[UIScreen mainScreen].bounds.size.width/2, 1, [UIScreen mainScreen].bounds.size.width/2-1, 79)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake((i-2)*[UIScreen mainScreen].bounds.size.width/2, 81, [UIScreen mainScreen].bounds.size.width/2-1, 78)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }
            } else if(array.count == 7)
            {
                if (i < 1)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame8:CGRectMake(0, 1, [UIScreen mainScreen].bounds.size.width/2 -1, 199)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else if (i <= 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100*(i-1)+1, [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }
                else{
                    backView = [[FYMenuBtnView alloc] initWithFrame6:CGRectMake((i-3)*[UIScreen mainScreen].bounds.size.width/4, 201, [UIScreen mainScreen].bounds.size.width/4-1, 118)
                                
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                }
            } else if(array.count == 8)
            {
                if (i < 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake(0, 100*i+1, [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else if (i <= 3)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100*(i-2)+1, [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }
                else{
                    backView = [[FYMenuBtnView alloc] initWithFrame6:CGRectMake((i-4)*[UIScreen mainScreen].bounds.size.width/4, 201, [UIScreen mainScreen].bounds.size.width/4-1, 118)
                                
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                }
            } else if(array.count == 9)
            {NSLog(@"你好啊 啊啊啊啊啊");
                if (i < 1)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake(0, 100*i, [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else if (i <= 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100*(i-1), [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }
                else{
                    backView = [[FYMenuBtnView alloc] initWithFrame6:CGRectMake((i-4)*[UIScreen mainScreen].bounds.size.width/4, 201, [UIScreen mainScreen].bounds.size.width/4-1, 118)
                                
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                }
            }
            else
            {
                if (i < 1)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame8:CGRectMake(0, 1, [UIScreen mainScreen].bounds.size.width/2 -1, 199)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                            imagestr:act[@"image"]];
                    
                    
                }else if (i <= 2)
                {
                    backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100*(i-1)+1, [UIScreen mainScreen].bounds.size.width/2-1, 99)
                                                            subtitle:act[@"subtitle"]
                                                               title:act[@"title"]
                                                             tuijian:act[@"tag"]
                                                            imagestr:act[@"image"]];
                    
                    
                }
                else{
                    backView = [[FYMenuBtnView alloc] initWithFrame7:CGRectMake((i-3)*[UIScreen mainScreen].bounds.size.width/2, 201, [UIScreen mainScreen].bounds.size.width/2-1, 98)
                                
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

/*
+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withArray:(NSArray *)array//输出当前cell大小
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width/2;
    CGFloat heigth = 80;
    CGFloat cellHeight = 0;
    CGFloat maxHeight = 0;
    for (int i = 0; i < array.count; i++)
    {
        NSInteger col = [[array[i] objectForKey:@"adv_col"] integerValue];//列
        NSInteger row = [[array[i] objectForKey:@"adv_row"] integerValue];//行
        NSInteger block_width = [[array[i] objectForKey:@"adv_block_width"] integerValue];//宽
        NSInteger block_height = [[array[i] objectForKey:@"adv_block_height"] integerValue];//高
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(width*(col-1),heigth*(row-1), width*block_width, heigth*block_height)];
        cellHeight = CGRectGetMaxY(backView.frame);
        if (cellHeight > maxHeight)
        {
            maxHeight = cellHeight;
        }
    }
    
    return maxHeight;
}
*/

-(void)OnTapBackView:(UITapGestureRecognizer *)sender//点击触发 手势
{
    UIView *backView = (UIView *)sender.view;
    int tag = (int)backView.tag-100;
    [self.delegate didSelectedHomeBlock2AtIndex:tag];
}

@end
