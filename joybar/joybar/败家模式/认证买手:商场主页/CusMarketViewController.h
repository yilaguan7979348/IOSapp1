//
//  CusMarketViewController.h
//  joybar
//
//  Created by 123 on 15/11/16.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CusMarketViewController : BaseViewController

@property (nonatomic ,strong) NSString *storeId;
@property (nonatomic ,strong) NSString *marketName;
@property (nonatomic ,strong) NSString *describeStr;
@property (nonatomic ,strong) NSMutableArray *brandArr;
@property (nonatomic ,strong) NSString *locationStr;


@end
