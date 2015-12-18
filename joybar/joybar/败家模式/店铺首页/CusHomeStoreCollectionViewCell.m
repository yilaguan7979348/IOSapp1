//
//  CusHomeStoreCollectionViewCell.m
//  joybar
//
//  Created by 123 on 15/7/22.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusHomeStoreCollectionViewCell.h"

@implementation CusHomeStoreCollectionViewCell
{
    NSDictionary *dataDic;
}

-(void)setCollectionData:(NSDictionary *)dic andHeight:(NSInteger)height
{
    dataDic = dic;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGEHEiGHT, height)];
    NSString *imgUrl = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"pic"] objectForKey:@"pic"]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [self.contentView addSubview:imageView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Name"]];
    nameLab.numberOfLines = 2;
    nameLab.font = [UIFont systemFontOfSize:13];
    
    
//    CGSize size = [Public getContentSizeWith:nameLab.text andFontSize:13 andWidth:IMAGEHEiGHT-10];
//    if (size.height>30)
//    {
        nameLab.frame = CGRectMake(5, 5, IMAGEHEiGHT-10, 35);
//    }
//    else
//    {
//        nameLab.frame = CGRectMake(5, 5, IMAGEHEiGHT-10, size.height);
//    }
//    nameLab.frame = CGRectMake(5, 5, IMAGEHEiGHT-10, size.height);

    [bgView addSubview:nameLab];
    
    //白色背景高度
    bgView.frame =CGRectMake(0, height, IMAGEHEiGHT, 35+35);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, nameLab.bottom+12, 11, 11)];
    label.text = @"￥";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:11];
    [bgView addSubview:label];
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(label.right+1, nameLab.bottom+7, 80, 20)];
    priceLab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Price"]];
    priceLab.textColor = [UIColor redColor];
    priceLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:priceLab];
    
    UIButton *clickZan = [UIButton buttonWithType:(UIButtonTypeCustom)];
    clickZan.frame = CGRectMake(IMAGEHEiGHT-50, nameLab.bottom+7, 60, 20);
    clickZan.backgroundColor = [UIColor clearColor];
    if (![[dic objectForKey:@"IsFavorite"] boolValue])
    {
        [clickZan setImage:[UIImage imageNamed:@"weishoucang"] forState:(UIControlStateNormal)];
        clickZan.selected = NO;
    }
    else
    {
        [clickZan setImage:[UIImage imageNamed:@"yishoucang"] forState:(UIControlStateNormal)];
        clickZan.selected = YES;
    }
    
//    NSString *count =[NSString stringWithFormat:@" %@",[dic objectForKey:@"FavoriteCount"]];
//    [clickZan setTitle:count forState:(UIControlStateNormal)];
//
//    clickZan.titleLabel.font = [UIFont systemFontOfSize:14];
//    [clickZan setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
//    clickZan.userInteractionEnabled = YES;
    [clickZan addTarget:self action:@selector(didClickCancelCollect:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:clickZan];
}

-(void)didClickCancelCollect:(UIButton *)btn
{
    if (!TOKEN)
    {
        [Public showLoginVC:self.viewController];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[dataDic objectForKey:@"Id"] forKey:@"Id"];
    if (btn.selected)
    {
        [dic setValue:@"0" forKey:@"Status"];
    }
    else
    {
        [dic setValue:@"1" forKey:@"Status"];
    }
    [HttpTool postWithURL:@"Product/Favorite" params:dic isWrite:YES  success:^(id json) {
        
        if ([json objectForKey:@"isSuccessful"])
        {
            if (btn.selected)
            {
                [btn setImage:[UIImage imageNamed:@"weishoucang"] forState:(UIControlStateNormal)];
                btn.selected = NO;
            }
            else
            {
                [btn setImage:[UIImage imageNamed:@"yishoucang"] forState:(UIControlStateNormal)];
                btn.selected = YES;
            }
            [self.delegate collectHandle];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
    }];
    
    
}

@end
