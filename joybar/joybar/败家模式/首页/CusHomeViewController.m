//
//  CusHomeViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusHomeViewController.h"
#import "CusCenterViewController.h"
#import "CusHomeTableViewCell.h"
#import "NSTimer+Addition.h"
#import "CusBuyerDetailViewController.h"
#import "BaseTableView.h"
#import "HomeData.h"
#import "Banner.h"
#import "HomeProduct.h"
#import "BaseNavigationController.h"
#import "MyBuyerTableView.h"
#import "HomeTableView.h"
@interface CusHomeViewController ()

@property (nonatomic ,strong) UIScrollView *homeScroll;

@property (nonatomic ,strong) UILabel *lineLab;

@property (nonatomic ,strong) HomeTableView *homeTableView;

@property (nonatomic ,assign) CGFloat startX;
@property (nonatomic ,assign) CGFloat endX;

@property (nonatomic ,strong) CycleScrollView * csView;

@property (nonatomic ,strong) NSArray *imageArr;
@property (nonatomic ,assign) NSInteger pageNum;

@property (nonatomic ,strong) NSMutableArray *homeArr;
@property (nonatomic ,strong) HomeData *data;
@property (nonatomic ,strong) MyBuyerTableView *myBuyerTableView;
@property (nonatomic ,strong) NSMutableArray *myBuyerArr;
@property (nonatomic ,assign) NSInteger myBuyerPageNum;

@end

@implementation CusHomeViewController
{
    UIView *tempView;
    CusCenterViewController *centerVC;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.csView.animationTimer pauseTimer];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.csView.animationTimer resumeTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    self.myBuyerPageNum = 1;
    self.homeArr = [NSMutableArray array];
    self.myBuyerArr = [NSMutableArray array];
    
    self.homeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.homeScroll.contentSize = CGSizeMake(kScreenWidth*2, 0);
    self.homeScroll.alwaysBounceVertical = NO;
    self.homeScroll.pagingEnabled = YES;
    self.homeScroll.delegate = self;
    self.homeScroll.directionalLockEnabled = YES;
    self.homeScroll.showsHorizontalScrollIndicator = NO;
    self.homeScroll.bounces = NO;
    self.homeScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.homeScroll];
    
    [self initWithFirstTableView];
    [self initWithSecondTableView];
    [self initNavView];
    
    //    购物车按钮
    //    UIButton *cartBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //    cartBtn.frame = CGRectMake(kScreenWidth-54, 10, 64, 64);
    //    cartBtn.backgroundColor = [UIColor clearColor];
    //    [cartBtn setImage:[UIImage imageNamed:@"购物车"] forState:(UIControlStateNormal)];
    //    [cartBtn addTarget:self action:@selector(didClickCartBtnBtn) forControlEvents:(UIControlEventTouchUpInside)];
    //    [self.navView addSubview:cartBtn];

    [self getData:NO];
}
-(void)initNavView
{
    [self addNavBarViewAndTitle:@""];
    self.retBtn.hidden = YES;
    tempView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth-100, 64)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.center = self.navView.center;
    [self.navView addSubview:tempView];
    
    //    NSArray *nameArr = @[@"买手街",@"TA们说",@"我的买手"];
    NSArray *nameArr = @[@"买手街",@"我的买手"];
    
    for (int i=0; i<nameArr.count; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(tempView.width/2*i, 18, tempView.width/2, 50)];
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont fontWithName:@"youyuan" size:15];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.text = [nameArr objectAtIndex:i];
        lab.tag=1000+i;
        [tempView addSubview:lab];
        if (i==0)
        {
            lab.textColor = [UIColor orangeColor];
            lab.font = [UIFont fontWithName:@"youyuan" size:17];
            
            self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 3)];
            self.lineLab.center = CGPointMake(lab.center.x, 63);
            self.lineLab.backgroundColor = [UIColor orangeColor];
            [tempView addSubview:self.lineLab];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
        [lab addGestureRecognizer:tap];
    }
}

-(void)initWithFirstTableView
{
    //tableView
    self.homeTableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    [self.homeScroll addSubview:self.homeTableView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2+40)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.homeTableView.tableHeaderView = headerView;

    self.csView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2) animationDuration:3.5];
    self.csView.datasource = self;
    self.csView.delegate = self;
    [headerView addSubview:self.csView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, self.csView.height+10, kScreenWidth, 20)];
    lab.text = @"最新上新";
    lab.font = [UIFont fontWithName:@"youyuan" size:16];
    lab.backgroundColor = [UIColor clearColor];
    [headerView addSubview:lab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, lab.bottom+10, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:line];

    __weak CusHomeViewController *VC = self;
    self.homeTableView.headerRereshingBlock = ^()
    {
        [VC.homeTableView.dataArr removeAllObjects];
        VC.pageNum=1;
        [VC getData:YES];
    };
    self.homeTableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
        [VC getData:YES];
    };

}

-(void)initWithSecondTableView
{
    self.myBuyerTableView = [[MyBuyerTableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64-49) style:(UITableViewStylePlain)];
    [self.homeScroll addSubview:self.myBuyerTableView];
    
    __weak CusHomeViewController *VC = self;
    self.myBuyerTableView.headerRereshingBlock = ^()
    {
        [VC.myBuyerTableView.dataArr removeAllObjects];
        VC.myBuyerPageNum = 1;
        [VC getMyBuyerData:YES];
    };
    self.myBuyerTableView.footerRereshingBlock = ^()
    {
        VC.myBuyerPageNum++;
        [VC getMyBuyerData:YES];
    };
}

-(void)getMyBuyerData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.myBuyerPageNum] forKey:@"page"];
    [dic setValue:@"6" forKey:@"pagesize"];
    if (!isRefresh)
    {
        [SVProgressHUD show];
    }
    [HttpTool postWithURL:@"Product/MyBuyer" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSDictionary *dic = [[json objectForKey:@"data"] objectForKey:@"items"];
            
            _data = [HomeData objectWithKeyValues:dic];
            
            if (_data.Products.count<6)
            {
                [self.myBuyerTableView hiddenFooter:YES];
            }
            else
            {
                [self.myBuyerTableView hiddenFooter:NO];
            }
            
            [self.myBuyerTableView.dataArr addObjectsFromArray:self.data.Products];
            
        }
        [self.myBuyerTableView reloadData];
        [self.myBuyerTableView endRefresh];
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)getData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setValue:@"6" forKey:@"pagesize"];
    if (!isRefresh)
    {
        [SVProgressHUD show];
    }
    [HttpTool postWithURL:@"Product/Index" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSDictionary *dic = [[json objectForKey:@"data"] objectForKey:@"items"];
            _data = [HomeData objectWithKeyValues:dic];
            if (_data.Products.count<6)
            {
                [self.homeTableView hiddenFooter:YES];
            }
            else
            {
                [self.homeTableView hiddenFooter:NO];
            }
            [self.homeTableView.dataArr addObjectsFromArray:self.data.Products];
            [self.csView reloadData];
            [SVProgressHUD dismiss];
        }
        [self.homeTableView reloadData];
        [self.homeTableView endRefresh];
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger) totalPagesCount
{
    return self.data.Banners.count;
}

- (UIView *) fetchContentViewAtIndex:(NSInteger)pageIndex
{
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/2)];
    imgView.backgroundColor = [UIColor lightGrayColor];
    
    Banner *banner = [self.data.Banners objectAtIndex:pageIndex];
    NSString *temp =[NSString stringWithFormat:@"%@_320x0.jpg",banner.Pic];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:nil];
    return imgView;
}

#pragma mark ScrollViewDeletegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.endX = scrollView.contentOffset.x;
    
    if (self.startX-self.endX==0)
    {
        return;
    }
    if (scrollView.contentOffset.x==0)
    {
        [self scrollToBuyerStreet];
    }
//    else if(scrollView.contentOffset.x==kScreenWidth)
//    {
//        [self scrollToSaid];
//    }
    else
    {
        [self scrollToMyBuyer];
    }
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {
        self.homeScroll.contentOffset = CGPointMake(0, 0);
        [self scrollToBuyerStreet];
    }
    else if(tap.view.tag==1001)
    {
        self.homeScroll.contentOffset = CGPointMake(kScreenWidth, 0);
//        [self scrollToSaid];
        [self scrollToMyBuyer];
    }
//    else
//    {
//        self.homeScroll.contentOffset = CGPointMake(kScreenWidth*2, 0);
//        [self scrollToMyBuyer];
//    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startX = scrollView.contentOffset.x;
}

//买手街
-(void)scrollToBuyerStreet
{
    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
    UILabel *lab3 = (UILabel *)[tempView viewWithTag:1002];

    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 63);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:17];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:15];
    lab3.textColor = [UIColor grayColor];
    lab3.font = [UIFont fontWithName:@"youyuan" size:15];
}

////TA们说
//-(void)scrollToSaid
//{
//    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
//    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
//    UILabel *lab3 = (UILabel *)[tempView viewWithTag:1002];
//    if (centerVC==nil)
//    {
//        centerVC= [[CusCenterViewController alloc] init];
//        centerVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64);
//        [self.homeScroll addSubview:centerVC.view];
//    }
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        self.lineLab.center = CGPointMake(lab2.center.x, 63);
//    }];
//    lab2.textColor = [UIColor orangeColor];
//    lab2.font = [UIFont fontWithName:@"youyuan" size:17];
//    lab1.textColor = [UIColor grayColor];
//    lab1.font = [UIFont fontWithName:@"youyuan" size:15];
//    lab3.textColor = [UIColor grayColor];
//    lab3.font = [UIFont fontWithName:@"youyuan" size:15];
//
//}

-(void)scrollToMyBuyer
{
    if (self.myBuyerTableView.dataArr.count==0)
    {
        [self getMyBuyerData:NO];
    }

    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
//    UILabel *lab3 = (UILabel *)[tempView viewWithTag:1002];
//    if (myBuyerVC==nil)
//    {
//        myBuyerVC= [[CusMyBuyerViewController alloc] init];
//        myBuyerVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64);
//        [self.homeScroll addSubview:myBuyerVC.view];
//    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 63);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont fontWithName:@"youyuan" size:17];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont fontWithName:@"youyuan" size:15];
//    lab2.textColor = [UIColor grayColor];
//    lab2.font = [UIFont fontWithName:@"youyuan" size:15];

}

//点击购物车
-(void)didClickCartBtnBtn
{
    
}

@end
