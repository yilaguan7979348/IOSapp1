//
//  CusFindViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusMoreBrandViewController.h"
#import "CusFindSearchViewController.h"
#import "CusBrandDetailViewController.h"
#import "MoreBrandTableView.h"
#import "NearData.h"
#import "AppDelegate.h"
@interface CusMoreBrandViewController ()<UIScrollViewDelegate>

@property (nonatomic ,strong) MoreBrandTableView *findTableView;
@property (nonatomic ,strong) NSMutableArray *findArr;
@property (nonatomic ,assign) NSInteger pageNum;

@end

@implementation CusMoreBrandViewController
{
    UIView *tempView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBarViewAndTitle:@""];
    UITextField *search = [[UITextField alloc] init];
    search.center = CGPointMake(kScreenWidth/2, 64/2+10);
    search.bounds = CGRectMake(0, 0, kScreenWidth-100, 30);
    search.placeholder = @"  搜索品牌";
    search.borderStyle = UITextBorderStyleNone;
    search.layer.cornerRadius = 3;
    search.layer.masksToBounds = YES;
    search.font = [UIFont systemFontOfSize:14];
    search.backgroundColor = kCustomColor(238, 238, 238);
    [self.navView addSubview:search];
    self.pageNum = 1;
    [self initWithFindTableView];
    [self getFindData:NO];
    
}

//品牌
-(void)initWithFindTableView
{
    //tableView
    self.findTableView = [[MoreBrandTableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    [self.view addSubview:self.findTableView];
    
    __weak CusMoreBrandViewController *VC = self;
    self.findTableView.headerRereshingBlock = ^()
    {
        [VC.findTableView.dataArr removeAllObjects];
        VC.pageNum=1;
        [VC getFindData:YES];
    };
    self.findTableView.footerRereshingBlock = ^()
    {
        VC.pageNum++;
        [VC getFindData:YES];
    };
}

-(void)getFindData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.storeId forKey:@"StoreId"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"page"];
    [dic setValue:@"20" forKey:@"pagesize"];
    if (!isRefresh)
    {
        [self activityDismiss];
        [self showInView:self.view WithPoint:CGPointMake(0, 0) andHeight:kScreenHeight-64-49];
    }
    [HttpTool postWithURL:@"v3/storebrand" params:dic success:^(id json) {
        
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            if (arr.count<20)
            {
                [self.findTableView hiddenFooter:YES];
            }
            else
            {
                [self.findTableView hiddenFooter:NO];
            }
            [self.findTableView.dataArr addObjectsFromArray:arr];
            [self.findTableView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.findTableView endRefresh];
        [self activityDismiss];
        
    } failure:^(NSError *error) {
        [self.findTableView endRefresh];
        [self activityDismiss];
    }];
}

//点击搜索
-(void)didClickSearch
{
    CusFindSearchViewController *VC = [[CusFindSearchViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

@end