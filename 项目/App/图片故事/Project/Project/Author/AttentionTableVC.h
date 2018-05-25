//
//  AttentionTableVC.h
//  Project
//
//  Created by masha on 2018/5/17.
//  Copyright © 2018年 邹笛. All rights reserved.
//
#import "BaseViewController.h"
@class AuthorModel;

@interface AttentionTableVC : BaseTableViewController

@end

@interface AttentionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *collect;
@property (nonatomic, strong)AuthorModel *model;
@property (nonatomic, copy) void (^deleteAutor)(id sender);
@end
