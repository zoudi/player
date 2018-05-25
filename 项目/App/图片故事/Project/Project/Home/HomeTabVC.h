//
//  HomeTabVC.h
//  majia
//
//  Created by pg on 2018/5/10.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseViewController.h"

@class PictureStoryModel;
@interface HomeTabVC : UITableViewController

@end

@interface ImageItemCell :UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;
@property (strong, nonatomic) IBOutlet UILabel *avatarName;
@property (strong, nonatomic) IBOutlet UILabel *publishDate;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) PictureStoryModel *pictureStoryModel;
@property (weak, nonatomic) IBOutlet UIButton *collect;

@property (nonatomic, copy) void (^TapClick)(id sender);
@property (nonatomic, copy) void (^BtnClick)(id sender);
@end
