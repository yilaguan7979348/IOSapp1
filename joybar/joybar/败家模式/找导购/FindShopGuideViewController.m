//
//  FindShopGuideViewController.m
//  joybar
//
//  Created by joybar on 15/11/23.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "FindShopGuideViewController.h"
#import "HJCarouselViewLayout.h"
#import "HJCarouselViewCell.h"
#import "HJConcernCell.h"
#import "HJHeaderViewCell.h"

@interface FindShopGuideViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic ,strong) UILabel *lineLab;
@property (nonatomic ,strong)UICollectionView *cusCollectView;
@property (nonatomic ,strong)UICollectionView *cusCollectView1;
@property (nonatomic ,strong)UICollectionView *cusCollectView2;


@property (nonatomic ,strong) UIScrollView *messageScroll;

@end
static NSString * const reuseIdentifier = @"Cell";

@implementation FindShopGuideViewController{
    UIView *tempView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarViewAndTitle:@""];
    self.retBtn.hidden = YES;
    tempView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, kScreenWidth-150, 64)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.center = self.navView.center;
    [self.navView addSubview:tempView];
    
    NSArray *nameArr = @[@"导购",@"关注"];
    for (int i=0; i<2; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(tempView.width/2*i, 18, tempView.width/2, 50)];
        lab.userInteractionEnabled = YES;
        lab.font = [UIFont systemFontOfSize:15];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.text = [nameArr objectAtIndex:i];
        lab.tag=1000+i;
        [tempView addSubview:lab];
        if (i==0)
        {
            lab.textColor = [UIColor orangeColor];
            lab.font = [UIFont systemFontOfSize:17];
            
            self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 3)];
            self.lineLab.center = CGPointMake(lab.center.x, 63);
            self.lineLab.backgroundColor = [UIColor orangeColor];
            [tempView addSubview:self.lineLab];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect:)];
        [lab addGestureRecognizer:tap];
    }
    
    self.messageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.messageScroll.alwaysBounceVertical = NO;
    self.messageScroll.pagingEnabled = YES;
    self.messageScroll.delegate = self;
    self.messageScroll.directionalLockEnabled = YES;
    self.messageScroll.showsHorizontalScrollIndicator = NO;
    self.messageScroll.bounces = NO;
    self.messageScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.messageScroll];

    
    
    HJCarouselViewLayout *layout  = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
    layout.itemSize = CGSizeMake(kScreenWidth-70, kScreenHeight-168);
    layout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    
    _cusCollectView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) collectionViewLayout:layout];
    _cusCollectView.dataSource =self;
    _cusCollectView.delegate =self;
    _cusCollectView.showsHorizontalScrollIndicator = NO;
    _cusCollectView.showsVerticalScrollIndicator = NO;
    _cusCollectView.backgroundColor =[UIColor whiteColor];
    [self.messageScroll addSubview:_cusCollectView];
    [self.cusCollectView registerNib:[UINib nibWithNibName:NSStringFromClass([HJCarouselViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    //关注
    UIView *gzView =[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth*2, kScreenHeight)];
    [self.messageScroll addSubview:gzView];
    
 
    
    
    
    
    HJCarouselViewLayout *layout1  = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];

    layout1.itemSize = CGSizeMake(kScreenWidth-70, kScreenHeight-298);
    layout1.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    
    _cusCollectView1 =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 115, kScreenWidth, kScreenHeight-298) collectionViewLayout:layout1];
    _cusCollectView1.dataSource =self;
    _cusCollectView1.delegate =self;
    _cusCollectView1.showsHorizontalScrollIndicator = NO;
    _cusCollectView1.showsVerticalScrollIndicator = NO;
    _cusCollectView1.backgroundColor =[UIColor whiteColor];
    [gzView addSubview:_cusCollectView1];

    [self.cusCollectView1 registerNib:[UINib nibWithNibName:NSStringFromClass([HJConcernCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    UILabel *adLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, _cusCollectView1.bottom+10, kScreenWidth, 14)];
    adLabel.text =@"中关村南大街6号";
    adLabel.textAlignment =NSTextAlignmentCenter;
    adLabel.font =[UIFont systemFontOfSize:14];
    [gzView addSubview:adLabel];


    
    //头
    HJCarouselViewLayout *layout2  = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimLinear];
    layout2.itemSize = CGSizeMake(75, 100);
    layout2.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    
    _cusCollectView2 =[[UICollectionView alloc]initWithFrame:CGRectMake(40, 10, kScreenWidth-80, 100) collectionViewLayout:layout2];
    _cusCollectView2.dataSource =self;
    _cusCollectView2.delegate =self;
    _cusCollectView2.showsHorizontalScrollIndicator = NO;
    _cusCollectView2.showsVerticalScrollIndicator = NO;
    _cusCollectView2.backgroundColor =[UIColor whiteColor];
    [gzView addSubview:_cusCollectView2];
    [self.cusCollectView2 registerNib:[UINib nibWithNibName:NSStringFromClass([HJHeaderViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    [gzView addSubview:_cusCollectView2];
    
    
}

- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self.cusCollectView indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self.cusCollectView layoutAttributesForItemAtIndexPath:path];
        if (!curIndexPath) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
            continue;
        }
        if (attributes.zIndex > curzIndex) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
        }
    }
    return curIndexPath;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *curIndexPath = [self curIndexPath];
    if (indexPath.row == curIndexPath.row) {
        return YES;
    }
    
    [self.cusCollectView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"click %ld", indexPath.row);
}





#pragma mark <UICollectionViewDataSource>
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HJCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

-(void)didSelect:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag==1000)
    {

        self.messageScroll.contentOffset = CGPointMake(0, 0);
        [self scrollToMessage];
    }
    else
    {
        self.messageScroll.contentOffset = CGPointMake(kScreenWidth, 0);
        [self scrollToDynamic];
    }
}


//导购
-(void)scrollToMessage
{
    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab1.center.x, 63);
    }];
    lab1.textColor = [UIColor orangeColor];
    lab1.font = [UIFont systemFontOfSize:17];
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont systemFontOfSize:15];
}

//关注
-(void)scrollToDynamic
{
    UILabel *lab1 = (UILabel *)[tempView viewWithTag:1000];
    UILabel *lab2 = (UILabel *)[tempView viewWithTag:1001];
    [UIView animateWithDuration:0.25 animations:^{
        self.lineLab.center = CGPointMake(lab2.center.x, 63);
    }];
    lab2.textColor = [UIColor orangeColor];
    lab2.font = [UIFont systemFontOfSize:17];
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont systemFontOfSize:15];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"1");
}


@end
