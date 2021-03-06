//
//  CusOrderDetailViewController.m
//  joybar
//
//  Created by 123 on 15/5/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusOrderDetailViewController.h"
#import "CusOrderDetailTableViewCell.h"
#import "OrderDetailData.h"
@interface CusOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) OrderDetailData *detailData;

@end

@implementation CusOrderDetailViewController
{
    UIButton *payBtn;
    UIButton *cancelBtn;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(245, 246, 247);
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addNavBarViewAndTitle:@"订单详情"];

    [self initBottomView];
    [self getData];
}

-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.orderId forKey:@"OrderNo"];
    [HttpTool postWithURL:@"Order/GetUserOrderDetail" params:dic success:^(id json) {
        
        if ([json objectForKey:@"isSuccessful"])
        {
            self.detailData = [OrderDetailData objectWithKeyValues:[json objectForKey:@"data"]];
            [self.tableView reloadData];
            
            /*
             待付款"  0,
             "取消"    -10,
             "已付款"  1,
             "退货处理中"  3,
             "已发货"   15,
             "用户已签收" 16,
             "完成"  18,
             */

            NSString *status = self.detailData.OrderStatus;
            if ([status isEqualToString:@"0"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = NO;
            }
            else if ([status isEqualToString:@"1"])
            {
                cancelBtn.hidden = NO;
                payBtn.hidden = NO;
                [cancelBtn setTitle:@"申请退款" forState:(UIControlStateNormal)];
                [payBtn setTitle:@"确认提货" forState:(UIControlStateNormal)];
            }
            else if ([status isEqualToString:@"16"]||[status isEqualToString:@"15"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = NO;
                [payBtn setTitle:@"申请退款" forState:(UIControlStateNormal)];
            }
            else if ([status isEqualToString:@"3"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = NO;
                [payBtn setTitle:@"撤销退款" forState:(UIControlStateNormal)];
            }
            else if ([status isEqualToString:@"-10"]||[status isEqualToString:@"18"])
            {
                cancelBtn.hidden = YES;
                payBtn.hidden = YES;
            }
        }
        else
        {
            
        }
        NSLog(@"%@",[json objectForKey:@"message"]);
    } failure:^(NSError *error) {
        
    }];
}
-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line];
    
    UIButton *chatBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    chatBtn.frame = CGRectMake(10, -5, 60, 49);
    [chatBtn setImage:[UIImage imageNamed:@"liaotian"] forState:(UIControlStateNormal)];
    [chatBtn addTarget:self action:@selector(didCLickMakeChatBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:chatBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(13, 28, 60, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"联系买手";
    lab.font = [UIFont fontWithName:@"youyuan" size:11];
    [bottomView addSubview:lab];
    
    payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    payBtn.frame = CGRectMake(kScreenWidth-90, 10, 70, 30);
    [payBtn setTitle:@"付款" forState:(UIControlStateNormal)];
    payBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
    [payBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    payBtn.layer.borderColor = [UIColor redColor].CGColor;
    payBtn.layer.borderWidth = 0.5;
    payBtn.layer.cornerRadius = 3;
    [payBtn addTarget:self action:@selector(didClickPayBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:payBtn];
    
    cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.frame = CGRectMake(payBtn.left-90, 10, 70, 30);
    [cancelBtn setTitle:@"取消订单" forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@"youyuan" size:14];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    cancelBtn.layer.borderColor = [UIColor blackColor].CGColor;
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.layer.cornerRadius = 3;
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView addSubview:cancelBtn];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = kCustomColor(245, 246, 247);
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 4;
    }
    else if (section==1)
    {
        return 3;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *iden = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        NSArray *arr = @[@"订单编号:",@"订单状态:",@"订单金额:",@"订单日期:"];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
        lab.textColor = [UIColor grayColor];
        lab.text = [arr objectAtIndex:indexPath.row];
        lab.font = [UIFont fontWithName:@"youyuan" size:15];
        [cell.contentView addSubview:lab];

        if (self.detailData)
        {
            NSArray *msgArr = @[self.detailData.OrderNo,self.detailData.OrderStatusName,[NSString stringWithFormat:@"￥%@",self.detailData.Price],self.detailData.CreateDate];
            UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake(lab.right+10, 15, kScreenWidth-110, 20)];
            msgLab.text = [msgArr objectAtIndex:indexPath.row];
            msgLab.font = [UIFont fontWithName:@"youyuan" size:15];
            [cell.contentView addSubview:msgLab];

        }
        
        return cell;

    }
    if (indexPath.section==1)
    {
        static NSString *iden = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        NSArray *arr = @[@"买手账号:",@"买手电话:",@"自提地址:"];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
        lab.textColor = [UIColor grayColor];
        lab.text = [arr objectAtIndex:indexPath.row];
        lab.font = [UIFont fontWithName:@"youyuan" size:15];
        [cell.contentView addSubview:lab];
        
        if (self.detailData)
        {
            NSArray *msgArr = @[self.detailData.BuyerName,self.detailData.BuyerMobile,self.detailData.PickAddress];
            UILabel *msgLab = [[UILabel alloc] init];
            msgLab.text = [msgArr objectAtIndex:indexPath.row];
            msgLab.font = [UIFont fontWithName:@"youyuan" size:15];
            [cell.contentView addSubview:msgLab];
            if (indexPath.row<2)
            {
                msgLab.frame = CGRectMake(lab.right+10, 15, 170, 20);
            }
            else
            {
                msgLab.numberOfLines = 0;
                CGSize size = [Public getContentSizeWith:[msgArr objectAtIndex:indexPath.row] andFontSize:15 andWidth:kScreenWidth-110];
                msgLab.frame = CGRectMake(lab.right+10, 15, kScreenWidth-110, size.height);
            }

        }
        
        if (indexPath.row==0)
        {
            UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, 5, 40, 40)];
            [headerImage sd_setImageWithURL:[NSURL URLWithString:self.detailData.BuyerLogo] placeholderImage:nil];
            headerImage.layer.cornerRadius = headerImage.width/2;
            headerImage.clipsToBounds = YES;
            [cell.contentView addSubview:headerImage];
        }
        if (indexPath.row==1)
        {
            UIButton *phoneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            phoneBtn.frame = CGRectMake(kScreenWidth-50, 5, 40, 40);
            [phoneBtn setImage:[UIImage imageNamed:@"电话icon"] forState:(UIControlStateNormal)];
            [phoneBtn addTarget:self action:@selector(didCLickMakephoneBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.contentView addSubview:phoneBtn];
            
        }
        return cell;
    }
    else
    {
        static NSString *iden = @"cell2";
        CusOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CusOrderDetailTableViewCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setData:self.detailData];
        
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 50;
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==2)
        {
            CGSize size = [Public getContentSizeWith:@"发生地方阿迪拉开始放假卡了是发生地方阿迪拉开始放假卡了" andFontSize:15 andWidth:kScreenWidth-110];
            return size.height+30;
        }
        return 50;
    }
    return 80;
}

    
//打电话
-(void)didCLickMakephoneBtn:(UIButton *)btn
{
    
}

//点击私聊
-(void)didCLickMakeChatBtn:(UIButton *)btn
{
    
}

//付款
-(void)didClickPayBtn:(UIButton *)btn
{
    
}

//取消订单
-(void)didClickCancelBtn:(UIButton *)btn
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 10;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}



@end
