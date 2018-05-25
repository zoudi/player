//
//  AuthorVC.h
//  majia
//
//  Created by pg on 2018/5/11.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class AuthorModel;
@interface AuthorVC : BaseTableViewController
@property (nonatomic,strong) AuthorModel *userMode;

@end

@interface AuthorHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *bannerView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImv;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) AuthorModel *authorModel;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end

@interface MYSegmentView : UIView <UIScrollViewDelegate>
@property (nonatomic,strong) IBOutlet UIScrollView *segmentScrollV;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic,strong) UIButton *seleBtn;
@property (strong, nonatomic) IBOutlet UIView *segmentView;
@property (strong, nonatomic) UIView *line;
@end
