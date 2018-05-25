//
//  CourseSectionTableVC.h
//  football
//
//  Created by masha on 2018/5/16.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseModel;
@interface CourseSectionTableVC : UITableViewController
@property (nonatomic, assign)NSInteger pid;
@end
@interface CourseSectionCell : UITableViewCell
@property (nonatomic, strong)CourseModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *couresImage;
@property (weak, nonatomic) IBOutlet UILabel *couresName;

@end
