//
//  ZDMoviePlayerController.h
//  football
//
//  Created by masha on 2018/5/25.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDMoviePlayerController : UIViewController
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, strong)NSString *videoClassifyId;
@end

@class CommentModel;
@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *userSex;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *commentDate;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (nonatomic, strong)CommentModel *model;
@end
