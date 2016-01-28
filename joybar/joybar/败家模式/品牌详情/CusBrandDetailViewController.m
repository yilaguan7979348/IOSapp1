//
//  CusBrandDetailViewController.m
//  joybar
//
//  Created by 123 on 15/4/28.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "CusBrandDetailViewController.h"
#import "MJRefresh.h"
#import "CusRProDetailViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CusHomeStoreCollectionViewCell.h"
#import "CusHomeStoreHeader.h"
#import "CusZProDetailViewController.h"
#define HEADER_IDENTIFIER @"WaterfallHeader"

@interface CusBrandDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic ,strong) NSMutableArray *tagArr;

@property (nonatomic ,assign) NSInteger pageNum;

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) NSMutableArray *tempArr;

@end


@implementation CusBrandDetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 1;
    self.tagArr = [NSMutableArray array];
    self.tempArr = [NSMutableArray array];
    
    self.view.backgroundColor = kCustomColor(234, 239, 239);
    
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = YES; //垂直方向遇到边框是否总是反弹
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CusHomeStoreCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [_collectionView registerClass:[CusHomeStoreHeader class]
        forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
               withReuseIdentifier:HEADER_IDENTIFIER];
    [self.view addSubview:_collectionView];

//    self.collectionView.headerHidden = NO;

    [self addNavBarViewAndTitle:self.BrandName];
    
    [self getData:NO];

    //    // 2.集成刷新控件
        [self addHeader];
        [self addFooter];
}

- (void)addHeader
{
    __weak CusBrandDetailViewController* vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        vc.pageNum = 1;
        [vc.tagArr removeAllObjects];
        [vc getData:YES];

    }];

//    [self.collectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __weak CusBrandDetailViewController *vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        vc.pageNum++;
        [vc getData:YES];
    }];
}


-(void)getData:(BOOL)isRefresh
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue: self.storeId forKey:@"StoreId"];
    [dic setValue: self.cityId forKey:@"CityId"];
    [dic setValue:self.BrandId forKey:@"BrandId"];
    [dic setValue:[[Public getUserInfo]objectForKey:@"id"] forKey:@"UserId"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"Page"];
    [dic setValue:@"24" forKey:@"PageSize"];
    [self hudShow];
    [HttpTool postWithURL:@"v3/brandproduct" params:dic success:^(id json) {

        [self hiddleHud];
        if ([[json objectForKey:@"isSuccessful"] boolValue])
        {
            NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"items"];
            
            if (arr.count<24)
            {
                self.collectionView.footerHidden = YES;
            }
            else
            {
                self.collectionView.footerHidden = NO;
            }
            [self.tagArr addObjectsFromArray:arr];
            for (int i=0; i<self.tagArr.count; i++)
            {
                NSString *isfavorite = [NSString stringWithFormat:@"%@",[self.tagArr[i] objectForKey:@"IsFavorite"]];
                if ([isfavorite boolValue])
                {
                    [self.tempArr addObject:@"1"];
                }
                else
                {
                    [self.tempArr addObject:@"0"];
                }
            }
            [self.collectionView reloadData];
        }
        else
        {
            [self showHudFailed:[json objectForKey:@"message"]];
        }
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];

    } failure:^(NSError *error) {

        [self hiddleHud];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *proId = [[self.tagArr objectAtIndex:indexPath.row] objectForKey:@"Id"];
    NSString *userLevel = [NSString stringWithFormat:@"%@",[[self.tagArr objectAtIndex:indexPath.row] objectForKey:@"UserLevel"]];
    if ([userLevel isEqualToString:@"8"])
    {
        CusRProDetailViewController *VC = [[CusRProDetailViewController alloc] init];
        VC.productId = proId;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        CusZProDetailViewController *VC = [[CusZProDetailViewController alloc] init];
        VC.productId = proId;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CusHomeStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    if (cell==nil)
    {
        cell = [[CusHomeStoreCollectionViewCell alloc]init];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (self.tagArr.count>0)
    {
        float height = [[[[self.tagArr objectAtIndex:indexPath.row] objectForKey:@"pic"] objectForKey:@"Ratio"] floatValue];
        cell.tempArr = self.tempArr;
        cell.indexPath = indexPath;

        [cell setCollectionData:[self.tagArr objectAtIndex:indexPath.row] andHeight:(kScreenWidth-15)/2*height];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tagArr.count>0)
    {
        NSDictionary *dic = [self.tagArr objectAtIndex:indexPath.row];
        NSString *text = [dic objectForKey:@"Name"];
        CGSize size = [Public getContentSizeWith:text andFontSize:13 andWidth:IMAGEHEiGHT-10];
        CGFloat itemH = (kScreenWidth-10)/2*[[[dic objectForKey:@"pic"] objectForKey:@"Ratio"] floatValue]+35+35;
        
        CGSize size1 = CGSizeMake((kScreenWidth-10)/2, itemH);
        
        return size1;
    }
    return CGSizeZero;
}


@end
