//
//  CourseSectionTableVC.h
//  football
//
//  Created by masha on 2018/5/16.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class CourseModel;
@class CourseSectionCell;

@protocol VideoListInfoCellDelegate <NSObject>

- (void)videoListCell:(CourseSectionCell *)cell downloadVideo:(CourseModel *)model;

@end

@interface CourseSectionTableVC : BaseTabLeViewController
@property (nonatomic, assign)NSInteger pid;
@end


@interface CourseSectionCell : UITableViewCell
@property (nonatomic, strong)CourseModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *couresImage;
@property (weak, nonatomic) IBOutlet UILabel *couresName;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (nonatomic, assign) BOOL isDownload;
@property (nonatomic, weak) id <VideoListInfoCellDelegate> delegate;
@end
