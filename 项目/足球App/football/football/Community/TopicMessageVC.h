//
//  TopicMessageVC.h
//  football
//
//  Created by masha on 2018/5/29.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class InvitationModel;
@interface TopicMessageVC : BaseViewController
@property (nonatomic, strong)InvitationModel *model;
@end

@class CommentModel;
@interface TopicCommunityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *userSex;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *commentDate;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, strong)CommentModel *model;
@end
