//
//  RepositoryTableVC.h
//  football
//
//  Created by masha on 2018/5/16.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RepositoryModel;
@interface RepositoryTableVC : UITableViewController

@end

@interface RepositoryCell : UITableViewCell
@property (nonatomic, strong)RepositoryModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *repositoryImage;
@property (weak, nonatomic) IBOutlet UILabel *repositoryTitle;



@end
