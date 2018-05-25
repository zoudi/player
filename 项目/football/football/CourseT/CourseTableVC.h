//
//  CourseTableVC.h
//  football
//
//  Created by masha on 2018/5/16.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseModel;
@interface CourseTableVC : UITableViewController

@end

@interface CourseCellItem : UITableViewCell
@property (nonatomic, strong)CourseModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *courseName;

@end
