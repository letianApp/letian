//
//  GQNewFeatureViewController.m
//  cheyongwang
//
//  Created by 郭茜 on 15/11/15.
//  Copyright © 2015年 郭茜. All rights reserved.
//

#import "GQNewFeatureViewController.h"
#import "GQFeatureCell.h"


@interface  GQNewFeatureViewController()

@property (nonatomic,weak) UIPageControl *pageControl;

@end

@implementation GQNewFeatureViewController

static NSString *FeatureID = @"feature";
#define FeatureImageCount  4
#define FeatureNameFormart @"y%ld"

-(void)viewDidLoad
{
    [super viewDidLoad];
   
    [self.collectionView registerClass:[GQFeatureCell class] forCellWithReuseIdentifier:FeatureID];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    self.pageControl.numberOfPages = FeatureImageCount;
    self.pageControl.center = CGPointMake(self.view.frame.size.width * 0.5 , self.view.frame.size.height - 20);
}


-(instancetype)init
{
    //初始化流水布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //最小间距
    layout.minimumInteritemSpacing = 0;
    //最小行间距
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_W, SCREEN_H);
    //滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return [self initWithCollectionViewLayout:layout];
}

/**
 *  懒加载分页空间
 */
-(UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self.view addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return _pageControl;
}


#pragma mark  代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;

    self.pageControl.currentPage = page;
}


-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return FeatureImageCount;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GQFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeatureID forIndexPath:indexPath];
    NSString *featureName = [NSString stringWithFormat:FeatureNameFormart,indexPath.row + 1];
    cell.image = [UIImage imageNamed:featureName];
    [cell setIndexPath:indexPath count:FeatureImageCount];
    return cell;
}



@end
