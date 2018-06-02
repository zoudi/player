//
//  CommunityTableVC.h
//  football
//
//  Created by masha on 2018/5/28.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityTableVC : UITableViewController

@end

@class InvitationModel;
@interface CommunityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIImageView *sex;
@property (nonatomic, strong)InvitationModel *model;

@end
