//
//  CusZProDetailCell.m
//  joybar
//
//  Created by 123 on 15/11/19.
//  Copyright © 2015年 卢兴. All rights reserved.
//

#import "CusZProDetailCell.h"
#import "ProductPicture.h"
#import "DWTagList.h"
@implementation CusZProDetailCell
{
    UIPageControl *pageControl;
    NSMutableArray *labArr;
    NSMutableArray *imageViewArr;
    NSInteger priceNum;
    UILabel *buyNumLab;
    NSMutableArray *btnArr;
    UIView *orangeLine;
    UIScrollView *scroll;
    DWTagList*sizeBtn;
//    NSArray *sizeArr;
    UILabel *sizeLab;
}
- (void)awakeFromNib {
    // Initialization code
}

-(void)setDetailData:(ProDetailData *)proData andIndex:(NSIndexPath *)indexPath
{
    labArr = [[NSMutableArray alloc] init];
    imageViewArr =[[NSMutableArray alloc] init];
    if (indexPath.section==0)
    {
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        imageScrollView.contentSize =CGSizeMake(proData.ProductPic.count*(kScreenWidth), 0);
        imageScrollView.alwaysBounceVertical = NO;
        imageScrollView.alwaysBounceHorizontal = YES;
        imageScrollView.pagingEnabled = YES;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.delegate = self;
        [self.contentView addSubview:imageScrollView];
        
        for (int i=0; i<proData.ProductPic.count; i++)
        {
            ProductPicture *pic = [proData.ProductPic objectAtIndex:i];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageScrollView.width*i, 0, imageScrollView.width, imageScrollView.width)];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            image.userInteractionEnabled = YES;
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",pic.Logo]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [imageScrollView addSubview:image];
        }
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, imageScrollView.bottom-30, kScreenWidth, 20)];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        [pageControl setBackgroundColor:[UIColor clearColor]];
        pageControl.currentPage = 0;
        if (proData.ProductPic.count==1)
        {
            pageControl.hidden = YES;
        }
        else
        {
            pageControl.hidden = NO;
        }
        pageControl.numberOfPages = proData.ProductPic.count;
        [self.contentView addSubview:pageControl];
        
        UILabel *priceLab = [[UILabel alloc] init];
        priceLab.font = [UIFont systemFontOfSize:20];
        priceLab.text = [NSString stringWithFormat:@"￥%@",proData.Price];
        CGSize priceSize = [Public getContentSizeWith:priceLab.text andFontSize:20 andHigth:20];
        priceLab.frame = CGRectMake(10, imageScrollView.bottom+5, priceSize.width, 20);
        priceLab.textColor = [UIColor redColor];
        [self.contentView addSubview:priceLab];
        
        UILabel *originalPriceLab = [[UILabel alloc] init];
        CGSize originalPriceSize = [Public getContentSizeWith:priceLab.text andFontSize:14 andHigth:20];
        originalPriceLab.text = [NSString stringWithFormat:@"￥%@",proData.UnitPrice];
        originalPriceLab.textColor = [UIColor grayColor];
        originalPriceLab.font = [UIFont systemFontOfSize:14];
        originalPriceLab.frame = CGRectMake(priceLab.right+10, imageScrollView.bottom+5, originalPriceSize.width+10, 20);
        [self.contentView addSubview:originalPriceLab];
        
        UILabel *grayLine = [[UILabel alloc] initWithFrame:CGRectMake(originalPriceLab.left, imageScrollView.bottom+16, originalPriceLab.width, 1)];
        grayLine.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:grayLine];
        
        UILabel *discountLab = [[UILabel alloc] init];
        discountLab.backgroundColor = [UIColor redColor];
        discountLab.text  = [NSString stringWithFormat:@"%.2f折",[proData.UnitPrice floatValue]/[proData.Price floatValue]];
        discountLab.textColor = [UIColor whiteColor];
        discountLab.font = [UIFont systemFontOfSize:11];
        discountLab.textAlignment = NSTextAlignmentCenter;
        CGSize discountSize = [Public getContentSizeWith:discountLab.text andFontSize:11 andHigth:20];
        discountLab.frame = CGRectMake(originalPriceLab.right+10, imageScrollView.bottom+7, discountSize.width+6, 16);
        [self.contentView addSubview:discountLab];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = proData.ProductName;
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.numberOfLines = 0;
        CGSize titleSize = [Public getContentSizeWith:titleLab.text andFontSize:14 andWidth:kScreenWidth-15];
        titleLab.frame = CGRectMake(10, priceLab.bottom+5, kScreenWidth-15, titleSize.height);
        [self.contentView addSubview:titleLab];
        
    }
    
    else if (indexPath.section==1)
    {
        UILabel *location = [[UILabel alloc]init];
        location.text = [NSString stringWithFormat:@"自提地址:%@",proData.PickAddress];
        location.numberOfLines = 2;
        CGSize locationSize = [Public getContentSizeWith:location.text andFontSize:13 andWidth:kScreenWidth-20];
        location.font = [UIFont systemFontOfSize:13];
        location.frame =CGRectMake(10, 10, kScreenWidth-20, locationSize.height);
        [self.contentView addSubview:location];
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, location.bottom+5, 15, 15)];
        imageView1.image = [UIImage imageNamed:@"打烊购时间icon"];
        [self.contentView addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, imageView1.bottom+5, imageView1.width, imageView1.height)];
        imageView2.image = [UIImage imageNamed:@"打烊购icon"];
        [self.contentView addSubview:imageView2];
        
        UILabel *nightLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView1.right+5, imageView1.top, kScreenWidth-60, imageView1.height)];
        nightLab.text = proData.Promotion.DescriptionText;
        nightLab.font = [UIFont systemFontOfSize:11];
        nightLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:nightLab];
        
        UILabel *nightLab1 = [[UILabel alloc] init];
        nightLab1.text = proData.Promotion.TipText;
        nightLab1.numberOfLines = 0;
        CGSize size = [Public getContentSizeWith:nightLab1.text andFontSize:11 andWidth:kScreenWidth-60];
        nightLab1.frame = CGRectMake(imageView2.right+5, imageView2.top, kScreenWidth-60, size.height);
        nightLab1.font = [UIFont systemFontOfSize:11];
        nightLab1.textColor = [UIColor grayColor];
        [self.contentView addSubview:nightLab1];
    }
    else if (indexPath.section==2)
    {
        UILabel *colorLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 35, 20)];
        colorLab.text = @"颜色:";
        colorLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:colorLab];
        
        for (int i=0; i<self.kuCunArr.count; i++)
        {
            //列
            NSInteger rank = i%4;
            //行
            NSInteger row = i/4;
            
            CGFloat x = 50+(55+10)*rank;
            CGFloat y = 10+row*75;
            
            UIImageView *colorImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 55, 55)];
            colorImage.tag = i+10;
            [colorImage sd_setImageWithURL:[NSURL URLWithString:[self.kuCunArr[i] objectForKey:@"Pic"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            [self.contentView addSubview:colorImage];
            colorImage.userInteractionEnabled = YES;
            [imageViewArr addObject:colorImage];
            
            UILabel *colorName = [[UILabel alloc] initWithFrame:CGRectMake(colorImage.left, colorImage.bottom, colorImage.width, 20)];
            colorName.text =[self.kuCunArr[i] objectForKey:@"ColorName"];
            colorName.font = [UIFont systemFontOfSize:13];
            colorName.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:colorName];
            
            [labArr addObject:colorName];
            
            if (i==0)
            {
                colorImage.layer.borderColor = [UIColor redColor].CGColor;
                colorImage.layer.borderWidth = 1;
                colorName.textColor = [UIColor redColor];
            }
            
            UITapGestureRecognizer *tap  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectColor:)];
            [colorImage addGestureRecognizer:tap];
        }
        
        NSInteger sizeY = self.kuCunArr.count/4*75+70;
        
        sizeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, sizeY+30, 35, 20)];
        sizeLab.text = @"尺码:";
        sizeLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:sizeLab];
        
        sizeBtn = [[DWTagList alloc] init];
        sizeBtn.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:sizeBtn];
        NSArray *arr = [[self.kuCunArr objectAtIndex:0] objectForKey:@"Size"];
        [sizeBtn setTags:arr];
        CGFloat height = [sizeBtn fittedSize].height;
        self.sizeHeight = height;
        sizeBtn.frame = CGRectMake(sizeLab.right+5, sizeLab.top-3, kScreenWidth-70, height);
        
        sizeBtn.clickBtnBlock = ^(UIButton *btn,NSInteger index)
        {
            NSLog(@"%d",index);
        };
        //数量
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(10, sizeBtn.bottom+20, 40, 20)];
        numLab.text = @"数量:";
        numLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:numLab];
        
        UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(numLab.right+6, sizeBtn.bottom+15, 120, 30)];
        numView.backgroundColor = kCustomColor(240, 240, 240);
        numView.layer.cornerRadius = 4;
        numView.layer.borderWidth = 0.5f;
        numView.layer.borderColor = kCustomColor(223, 223, 223).CGColor;
        [self.contentView addSubview:numView];
        
        UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        addBtn.frame = CGRectMake(numView.width-44, 0, 44, numView.height);
        [addBtn setImage:[UIImage imageNamed:@"加号icon"] forState:(UIControlStateNormal)];
        [addBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        addBtn.backgroundColor = [UIColor clearColor];
        [addBtn addTarget:self action:@selector(didCLickAddNum) forControlEvents:(UIControlEventTouchUpInside)];
        [numView addSubview:addBtn];
        
        UIButton *minusBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        minusBtn.frame = CGRectMake(0, 0, 44, numView.height);
        [minusBtn setImage:[UIImage imageNamed:@"减号可点击icon"] forState:(UIControlStateNormal)];
        [minusBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        minusBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        minusBtn.backgroundColor = [UIColor clearColor];
        [minusBtn addTarget:self action:@selector(didClickDecrease) forControlEvents:(UIControlEventTouchUpInside)];
        [numView addSubview:minusBtn];
        
        buyNumLab = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, numView.width-88, numView.height)];
        buyNumLab.backgroundColor = [UIColor whiteColor];
        buyNumLab.text = [NSString stringWithFormat:@"%d",priceNum];
        buyNumLab.textAlignment = NSTextAlignmentCenter;
        [numView addSubview:buyNumLab];
        
        UILabel *kuCunLab = [[UILabel alloc] initWithFrame:CGRectMake(numView.right+10, numView.top+5, 150, 20)];
        kuCunLab.textColor = [UIColor clearColor];
        kuCunLab.font = [UIFont systemFontOfSize:15];
        NSArray *sizeArr = [self.kuCunArr[0] objectForKey:@"Size"];
        kuCunLab.text = [NSString stringWithFormat:@"库存%@件",[sizeArr[0]objectForKey:@"Inventory"]];
        [self.contentView addSubview:kuCunLab];
        
        UILabel *service = [[UILabel alloc] initWithFrame:CGRectMake(10, kuCunLab.bottom+10, kScreenWidth-20, 20)];
        service.text = @"服务:由门店提供服务";
        service.textColor = [UIColor grayColor];
        service.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:service];
        
        UILabel *remind = [[UILabel alloc] initWithFrame:CGRectMake(10, service.bottom, kScreenWidth-20, 20)];
        remind.text = @"注意:该商品不支持退货";
        remind.textColor = [UIColor redColor];
        remind.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:remind];
    }
    else if (indexPath.section==3)
    {
        UILabel *brandLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 40)];
        brandLab.text = proData.BrandName;
        brandLab.textColor = [UIColor orangeColor];
        brandLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:brandLab];
        
        UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-100, 0, 80, 40)];
        location.text = proData.CityName;
        location.textAlignment = NSTextAlignmentRight;
        location.textColor = [UIColor darkGrayColor];
        location.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:location];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, location.bottom, kScreenWidth-10, 1)];
        line.backgroundColor = kCustomColor(241, 241, 241);
        [self.contentView addSubview:line];
        
        UIImageView *headerImage = [[UIImageView alloc] init];
        headerImage.frame = CGRectMake(10, line.bottom+10, 50, 50);
        [headerImage sd_setImageWithURL:[NSURL URLWithString:proData.BuyerLogo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        headerImage.layer.cornerRadius = headerImage.width/2;
        headerImage.clipsToBounds = YES;
        headerImage.userInteractionEnabled = YES;
        [self.contentView addSubview:headerImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCLickToStore)];
        [headerImage addGestureRecognizer:tap];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.right+10, headerImage.top+5, kScreenWidth, 20)];
        nameLab.text = proData.BuyerName;
        //    NSString *htmlString = @"div class="">本帖属于CocoaChina</a>会员发表，转帖请写明来源和帖子地址</div>    as肯定不行。。。建议去看一下官方文档的Type Casting章节。。。要不后续会很坑自己    <br>    </div>    </div>    </td>";
        //    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        //    nameLab.attributedText = attributedString;
        nameLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:nameLab];
        
        UIImageView *locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(headerImage.right+8, nameLab.bottom+3, 13, 13)];
        locationImg.image = [UIImage imageNamed:@"location.png"];
        [self.contentView addSubview:locationImg];
        
        UILabel *locationNameLab = [[UILabel alloc] initWithFrame:CGRectMake(locationImg.right, nameLab.bottom, kScreenWidth-170, 20)];
        locationNameLab.text = proData.CityName;
        locationNameLab.font = [UIFont systemFontOfSize:13];
        locationNameLab.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:locationNameLab];
        
        UIButton *circleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        circleBtn.frame = CGRectMake(kScreenWidth-80, line.bottom+20, 60, 25);
        circleBtn.backgroundColor = [UIColor orangeColor];
        circleBtn.layer.masksToBounds = YES;
        circleBtn.layer.cornerRadius = 3;
        circleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [circleBtn setTitle:@"进圈" forState:(UIControlStateNormal)];
        [circleBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.contentView addSubview:circleBtn];
    }
    else
    {
        
        btnArr = [[NSMutableArray alloc] init];
        NSArray *arr = @[@"图片详情",@"尺码参考",@"售后服务"];
        for (int i=0; i<3; i++)
        {
            UIButton *btn =[UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.frame = CGRectMake(kScreenWidth/3*i, 0, kScreenWidth/3, 30);
            [btn setTitle:arr[i] forState:(UIControlStateNormal)];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.tag = 1000+i;
            if (i==0)
            {
                [btn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
            }
            else
            {
                [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.contentView addSubview:btn];
            [btnArr addObject:btn];
        }
        
        orangeLine = [[UIView alloc] initWithFrame:CGRectMake(25, 38, kScreenWidth/3-50, 2)];
        orangeLine.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:orangeLine];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 0.5)];
        line.backgroundColor = kCustomColor(238, 238, 238);
        [self.contentView addSubview:line];
        
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 210)];
        scroll.contentSize = CGSizeMake(kScreenWidth*3, 0);
        scroll.scrollEnabled = NO;
        [self.contentView addSubview:scroll];
        
        for (int i=0; i<proData.ProductPic.count; i++)
        {
            ProductPicture *pic = [proData.ProductPic objectAtIndex:i];
            
            UIImageView *proImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*210, kScreenWidth, 210)];
            [proImage sd_setImageWithURL:[NSURL URLWithString:pic.Logo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            [scroll addSubview:proImage];
        }
        
        UIImageView *sizeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, 210)];
        [sizeImage sd_setImageWithURL:[NSURL URLWithString:proData.SizeContrastPic] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [scroll addSubview:sizeImage];
        
        
        UILabel *storeService = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, 210)];
        
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[proData.StoreService dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        storeService.numberOfLines = 0;
        storeService.attributedText = attrStr;
        [scroll addSubview:storeService];
    }
}
//UIScrollViewDelegate方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    [pageControl setCurrentPage:index];
}

-(void)selectColor:(UITapGestureRecognizer *)tap
{
    NSArray *sizeArr = [[self.kuCunArr objectAtIndex:tap.view.tag-10] objectForKey:@"Size"];
    [sizeBtn setTags:sizeArr];
    CGFloat height = [sizeBtn fittedSize].height;
    sizeBtn.frame = CGRectMake(sizeLab.right+5, sizeLab.top-3, kScreenWidth-70, height);

    [self.delegate handleSizeHeight:height];

    UILabel *colorNameLab = [labArr objectAtIndex:tap.view.tag-10];
    UIImageView *colorImage = (UIImageView *)tap.view;
    
    for (UILabel *lab in labArr)
    {
        if ([colorNameLab isEqual:lab])
        {
            lab.textColor = [UIColor redColor];
        }
        else
        {
            lab.textColor = [UIColor blackColor];
        }
    }
    for (UIImageView *imageView in imageViewArr)
    {
        if ([imageView isEqual:colorImage])
        {
            imageView.layer.borderColor = [UIColor redColor].CGColor;
            imageView.layer.borderWidth = 1;
        }
        else
        {
            imageView.layer.borderColor = [UIColor clearColor].CGColor;
            imageView.layer.borderWidth = 0;
        }
    }
}

//增加
-(void)didCLickAddNum
{
    priceNum+=1;
    buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)priceNum];
}

//减少
-(void)didClickDecrease
{
    if (priceNum<1)
    {
        return;
    }
    else
    {
        priceNum-=1;
        buyNumLab.text = [NSString stringWithFormat:@"%ld",(long)priceNum];
    }
}

-(void)didCLickToStore
{
    
}

-(void)didClickBtn:(UIButton *)btn
{
    orangeLine.frame = CGRectMake((btn.tag-1000)*(kScreenWidth/3)+25, 38, kScreenWidth/3-50, 2);
    
    scroll.contentOffset = CGPointMake((btn.tag-1000)*kScreenWidth, 0);
    
    for (UIButton *selectBtn in btnArr)
    {
        if ([btn isEqual:selectBtn])
        {
            [selectBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
        }
        else
        {
            [selectBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        }
    }
}

@end
