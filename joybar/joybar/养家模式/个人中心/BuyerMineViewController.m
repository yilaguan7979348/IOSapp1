//
//  CusMineViewController.m
//  joybar
//
//  Created by 卢兴 on 15/4/16.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import "BuyerMineViewController.h"
#import "AppDelegate.h"
#import "BuyerTabBarViewController.h"
#import "BuyerSettingViewController.h"
#import "BueryAuthViewController.h"
#import "BuyerShopShowViewController.h"
#import "CusSettingViewController.h"


@interface BuyerMineViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UIViewController* vcview;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic,strong)UIView *bgHeaderView;
@property (nonatomic,strong)UIImageView *bgImageView;

@end

@implementation BuyerMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-44) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];

   
    
}

-(UIView *)setHeaderView{
    
    NSDictionary * dict=[Public getUserInfo];
    
   _bgHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 280)];
    
    UIButton *messageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    messageBtn.frame = CGRectMake(kScreenWidth-50, 30, 64, 64);
    messageBtn.backgroundColor = [UIColor clearColor];
    [messageBtn addTarget:self action:@selector(didClickSettingBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:messageBtn];
    UIImageView *messageImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    messageImg.image = [UIImage imageNamed:@"设置.png"];
    [messageBtn addSubview:messageImg];
    
    
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 265)];
    _bgImageView.image = [UIImage imageNamed:@"3.jpg"];
    [_bgHeaderView addSubview:_bgImageView];
    
    UIImageView *circleImage = [[UIImageView alloc] init];
    circleImage.center = CGPointMake(kScreenWidth/2, 110);
    circleImage.bounds = CGRectMake(0, 0, 75, 75);
    circleImage.layer.borderWidth = 0.5;
    circleImage.layer.cornerRadius = circleImage.width/2;
    circleImage.layer.borderColor = [UIColor whiteColor].CGColor;
    circleImage.backgroundColor = [UIColor clearColor];
    [_bgHeaderView addSubview:circleImage];
    
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.center = CGPointMake(circleImage.center.x, circleImage.center.y);
    headImage.bounds = CGRectMake(0, 0, 65, 65);
    headImage.layer.cornerRadius = headImage.width/2;
    headImage.clipsToBounds = YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"logo"]] placeholderImage:nil];
    [_bgHeaderView addSubview:headImage];
    
    UILabel *namelab =[[UILabel alloc] init];
    namelab.center = CGPointMake(headImage.center.x, circleImage.bottom+15);
    namelab.bounds = CGRectMake(0, 0, 150, 150);
    namelab.text = [dict objectForKey:@"nickname"];
    namelab.textColor = [UIColor whiteColor];
    namelab.textAlignment = NSTextAlignmentCenter;
    namelab.font = [UIFont fontWithName:@"youyuan" size:18];
    [_bgHeaderView addSubview:namelab];
    
    UIView *tempView = [[UIView alloc] init];
    tempView.center = CGPointMake(kScreenWidth/2, _bgImageView.bottom+43);
    tempView.bounds = CGRectMake(0, 0, 210, 70);
    tempView.backgroundColor = [UIColor clearColor];
    [_bgHeaderView addSubview:tempView];
    return _bgHeaderView;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:iden];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        NSArray *arr = @[@"店铺预览",@"店铺介绍"];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"youyuan" size:14];
        return cell;
        
    }else if(indexPath.section == 1){
        cell.textLabel.text = @"邀请买手";
        cell.textLabel.font = [UIFont fontWithName:@"youyuan" size:14];
        return cell;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"我要败家";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithName:@"youyuan" size:15];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            BuyerShopShowViewController *shop =[[BuyerShopShowViewController alloc]init];
            [self.navigationController pushViewController:shop animated:YES];
        }else if(indexPath.row ==0){
            NSLog(@"店铺预览");
        }
    }else if(indexPath.section ==1){
        NSLog(@"邀请买手");
    }else if (indexPath.section == 2) {
        [UIApplication sharedApplication].keyWindow.rootViewController =[[CusTabBarViewController alloc]init];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==2) {
        return 55;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
         return 280;
    }
    return 5;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        
        return [self setHeaderView];
        
    }
    return nil;
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y<0)
    {
        self.bgImageView.frame = CGRectMake(scrollView.contentOffset.y, scrollView.contentOffset.y, kScreenWidth-2*scrollView.contentOffset.y, 268-scrollView.contentOffset.y);
    }
}


//点击设置
-(void)didClickSettingBtn
{
    CusSettingViewController *VC = [[CusSettingViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
