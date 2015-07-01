//
//  BuyerPaymentDtsViewController.m
//  joybar
//
//  Created by joybar on 15/6/10.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerPaymentDtsViewController.h"
#import "BuyerPaymentTableViewCell.h"

@interface BuyerPaymentDtsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    int type;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong) UIView *tempView;
@property (nonatomic ,strong) BaseTableView *tableView;
@property (nonatomic ,strong) BaseTableView *tableView1;
@property (nonatomic ,assign) NSInteger pageNum;


@end

@implementation BuyerPaymentDtsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.pageNum=1;
    }
    return self;
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray ==nil) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)setData
{
    [self hudShow:@"正在加载"];
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dict setValue:@"6" forKey:@"Pagesize"];

    if (type ==1) {
        [dict setObject:@"1" forKey:@"status"];
    }else if(type ==2){
        [dict setObject:@"0" forKey:@"status"];
        
    }else if(type ==3){
        [dict setObject:@"2" forKey:@"status"];
    }else if(type ==4){
        [dict setObject:@"3" forKey:@"status"];
    }
    [HttpTool postWithURL:@"Buyer/PaymentGoodsList" params:dict success:^(id json) {
        
        BOOL isSuccessful = [[json objectForKey:@"isSuccessful"] boolValue];
        if (isSuccessful) {
            NSArray *arr =[[json objectForKey:@"data"]objectForKey:@"items"];
            if(arr.count<6)
            {
                [self.tableView hiddenFooter:YES];
                [self.tableView1 hiddenFooter:YES];
            }
            else
            {
                [self.tableView hiddenFooter:NO];
                [self.tableView1 hiddenFooter:NO];
            }
            if (self.pageNum==1) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
            }else{
                [self.dataArray addObjectsFromArray:arr];
            }
        }else{
            self.dataArray=nil;
            [self showHudFailed:@"加载失败"];
        }
        [self.tableView reloadData];
        [self.tableView1 reloadData];
        [self.tableView1 endRefresh];
        [self.tableView endRefresh];

        [self textHUDHiddle];

    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    type=1;
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    _tempView.backgroundColor = kCustomColor(251, 250, 250);
    [self.view addSubview:_tempView] ;
    NSArray *nameArr = @[@"可提现",@"冻结中",@"已提现",@"退款"];
    for (int i=0; i<4; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(_tempView.width/4*i, 0, _tempView.width/4, 35)];
        
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont fontWithName:@"youyuan" size:13];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.text = [nameArr objectAtIndex:i];
        lab.tag=1000+i;
        [_tempView addSubview:lab];
        if (i==0)
        {
            lab.textColor = [UIColor orangeColor];
            lab.font = [UIFont fontWithName:@"youyuan" size:15];
            
            self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tempView.width/5, 3)];
            self.lineLab.center = CGPointMake(lab.center.x, 38);
            self.lineLab.backgroundColor = [UIColor orangeColor];
            [_tempView addSubview:self.lineLab];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
        [lab addGestureRecognizer:tap];
       
    }
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39+64-0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    
    //tableView
    self.tableView= [[BaseTableView alloc]initWithFrame:CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-49-40) style:UITableViewStylePlain];
    self.tableView.tag = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kCustomColor(241, 241, 241);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    __weak BuyerPaymentDtsViewController *VC = self;
    self.tableView.headerRereshingBlock = ^()
    {
        if (VC.dataArray.count>0) {
            VC.dataArray =nil;
        }
        VC.pageNum = 1;
        [VC setData];
    };
    self.tableView.footerRereshingBlock =^(){
        VC.pageNum++;
        [VC setData];
    };
    
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    [btn setTitle:@"提现货款" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addNavBarViewAndTitle:@"货款收支"];
    [self setData];


}
-(void)btnClick{
    NSLog(@"提现货款");
}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cell1";
    BuyerPaymentTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"BuyerPaymentTableViewCell" owner:self options:nil] lastObject];
    }
    if (tableView.tag ==2) {
        if (type ==2) {
            cell.stateBtn.hidden =YES;
            cell.stateLabel.hidden=NO;
            cell.stateLabel.text =@"退款中";
        }else if(type ==3){
            cell.stateBtn.hidden =YES;
            cell.stateLabel.hidden=YES;
        }
        else if(type ==4){
            cell.stateBtn.hidden =YES;
            cell.stateLabel.hidden=NO;
            cell.stateLabel.text =@"已退款";

            
        }
    }else{
        cell.stateLabel.hidden=YES;
        cell.stateBtn.hidden =NO;
        [cell.stateBtn addTarget:self action:@selector(changeImg:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.dataArray.count>0) {
        cell.paymentPrice.text =[[self.dataArray[indexPath.row]objectForKey:@"Amount"]stringValue];
        cell.paymentNo.text =[self.dataArray[indexPath.row]objectForKey:@"OrderNo"];
        cell.paymentTime.text =[self.dataArray[indexPath.row]objectForKey:@"CreateDate"];
        cell.stateLabel.text =[self.dataArray[indexPath.row]objectForKey:@"StatusName"];


    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)changeImg:(UIButton *)btn{

    if(btn.selected ==NO){
        btn.selected =YES;
    }else{
        btn.selected =NO;
    }
    
}

-(void)showCountClick:(UIButton *)btn{
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        [self scrollToBuyerStreet];
        
    }
    else if(tap.view.tag==1001)
    {
        [self scrollToSaid];
    }
    else if(tap.view.tag==1002)
    {
        [self scrollToMyBuyer];
    }
    else
    {
        [self scrollToMyBuyer1];
    }
}

//全部订单
-(void)scrollToBuyerStreet
{
    type =1;
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 38);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:15];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont fontWithName:@"youyuan" size:13];
    
    [self.tableView1 removeFromSuperview];
    self.tableView1 =nil;
    self.pageNum=1;
    [self setData];
    
}

//待付款
-(void)scrollToSaid
{
    type =2;
    self.pageNum=1;
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    
    if (self.tableView1 ==nil) {
        self.tableView1= [[BaseTableView alloc] initWithFrame: CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];
        self.tableView1.dataSource=self;
        self.tableView1.delegate =self;
        self.tableView1.tag = 2;
        self.tableView1.backgroundColor = kCustomColor(241, 241, 241);
        self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView1.tableFooterView =[[UIView alloc]init];
        [self.view addSubview:self.tableView1];

    }
    __weak BuyerPaymentDtsViewController *VC = self;
    self.tableView1.headerRereshingBlock = ^()
    {
        if (VC.dataArray.count>0) {
            VC.dataArray=nil;
        }
        VC.pageNum=1;
        [VC setData];
        
    };
    self.tableView1.footerRereshingBlock =^(){
        VC.pageNum++;
        [VC setData];
    };
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 38);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:15];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont fontWithName:@"youyuan" size:13];
    [self setData];

    
}
//专柜自提
-(void)scrollToMyBuyer
{
    type =3;
    self.pageNum=1;
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
   
    
    if (self.tableView1 ==nil) {
        self.tableView1= [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];
        self.tableView1.dataSource=self;
        self.tableView1.delegate =self;
        self.tableView1.tag = 2;
        self.tableView1.tableFooterView =[[UIView alloc]init];
        [self.view addSubview:self.tableView1];

        
    }
    __weak BuyerPaymentDtsViewController *VC = self;
    self.tableView1.headerRereshingBlock = ^()
    {
        if (VC.dataArray.count>0) {
            VC.dataArray =nil;
        }
        VC.pageNum =1;
        [VC setData];
    };
    self.tableView1.footerRereshingBlock =^(){
        VC.pageNum++;
        [VC setData];
    };
    
    
    
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab3.center.x, 38);
    }];
    lab3.textColor = [UIColor orangeColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:15];
    lab4.textColor = [UIColor grayColor];
    lab4.font = [UIFont fontWithName:@"youyuan" size:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    [self setData];

}
//售后中心
-(void)scrollToMyBuyer1
{
    type =4;
    self.pageNum=1;
    UILabel *lab1 = (UILabel *)[_tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[_tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[_tempView viewWithTag:1002];
    UILabel *lab4 = (UILabel *)[_tempView viewWithTag:1003];
    
    
    if (self.tableView1 ==nil) {
        self.tableView1= [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64+40, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];

        self.tableView1.dataSource=self;
        self.tableView1.delegate =self;
        self.tableView1.tag = 2;
        self.tableView1.tableFooterView =[[UIView alloc]init];
        [self.view addSubview:self.tableView1];
    }
    __weak BuyerPaymentDtsViewController *VC = self;
    self.tableView1.headerRereshingBlock = ^()
    {
        if (VC.dataArray.count>0) {
            VC.dataArray =nil;
        }
        VC.pageNum=1;
        [VC setData];
    };
    self.tableView1.footerRereshingBlock =^(){
        VC.pageNum++;
        [VC setData];
    };
    [UIView animateWithDuration:0.1 animations:^{
        self.lineLab.center = CGPointMake(lab4.center.x, 38);
    }];
    lab4.textColor = [UIColor orangeColor];
    lab4.font = [UIFont fontWithName:@"youyuan" size:15];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:13];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:13];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:13];
    [self setData];

}

@end
