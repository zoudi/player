//
//  BaseCollectionView.m
//  PictureStory
//
//  Created by edz on 16/10/19.
//  Copyright © 2016年 cocoa_niu. All rights reserved.
//

#import "BaseCollectionView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation BaseCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0xEEEEF4);
        [self p_setupView];
        
    }
    return self;
}

- (void)p_setupView
{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    //设置最小行距
    flowlayout.minimumLineSpacing = 10;
    //设置最小左右间距
    flowlayout.minimumInteritemSpacing = 10;
    //设置cell大小
    flowlayout.itemSize = CGSizeMake(CGRectGetWidth(self.bounds) / 2 - 15, CGRectGetWidth(self.bounds) / 2 - 15);
    //设置滚动方向
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //边界范围
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //UICollectionView
    //第一个参数:frame
    //第二个参数:负责布局
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowlayout];
    
    self.collectionView.alwaysBounceVertical = YES;
//    EEEEF4
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.collectionView];
}


@end
