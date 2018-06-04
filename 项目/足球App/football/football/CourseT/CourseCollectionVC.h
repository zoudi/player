//
//  CourseCollectionVC.h
//  football
//
//  Created by masha on 2018/6/2.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseModel;
@interface CourseCollectionVC : UICollectionViewController

@end

@interface CoureseCollectionCellItem : UICollectionViewCell
@property (nonatomic, strong)CourseModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@end
