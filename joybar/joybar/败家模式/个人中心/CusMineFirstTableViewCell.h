//
//  CusMineFirstTableViewCell.h
//  joybar
//
//  Created by 123 on 15/5/5.
//  Copyright (c) 2015年 卢兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineData.h"
@interface CusMineFirstTableViewCell : UITableViewCell

-(void)setData:(MineData *)mineData andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic ,strong) UIImageView *bgImageView;

@end
