//
//  ZDMoviePlayerController.m
//  football
//
//  Created by masha on 2018/5/25.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "ZDMoviePlayerController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "YGPlayerView.h"
#import "MBProgressHUD+ZD.h"
#import "CourseModel.h"
#import "LoginTableVC.h"
#import "CommentModel.h"
#import "UserModel.h"

@interface ZDMoviePlayerController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *comment;
@property (weak, nonatomic) IBOutlet YGPlayerView *playerView;
@property (strong, nonatomic)NSMutableArray *commentArray;
@property (weak, nonatomic) IBOutlet UITableView *commentTabView;

@end

@implementation ZDMoviePlayerController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
    [query whereKey:@"videoClassifyId" equalTo:self.videoClassifyId];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (AVObject *obj in objects) {
            CommentModel *comment = [[CommentModel alloc] init];
            comment.title = [obj objectForKey:@"title"];
            comment.videoClassifyId = [obj objectForKey:@"videoClassifyId"];
            comment.createdAt = [obj objectForKey:@"createdAt"];
            if (!![obj objectForKey:@"user"]) {
                AVUser *us = [obj objectForKey:@"user"];
                UserModel *user = [[UserModel alloc]init];
                user.sex = [us objectForKey:@"sex"];
                user.signature = [us objectForKey:@"signature"];
                user.username = [us objectForKey:@"username"];
                user.birthday = [us objectForKey:@"birthday"];
                user.imageUrl = [us objectForKey:@"imageUrl"];
                user.mobilePhoneNumber = [us objectForKey:@"mobilePhoneNumber"];
                comment.user = user;
            }
            [self.commentArray addObject:comment];
            [self.commentTabView reloadData];
        }
        
    }];

    [self setupPlayerView];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning-------");
}

// 初始化播放器View
- (void)setupPlayerView
{
    YGPlayInfo *playInfo = [self.dataArray objectAtIndex:self.index];
    [self.playerView playWithPlayInfo:playInfo];
    [self.playerView setPlayInfos:self.dataArray];
}

- (IBAction)backAction:(id)sender {
    if (self.playerView.isLandscape) { // 转至竖屏
        [self.playerView setForceDeviceOrientation:UIDeviceOrientationPortrait];
    }else{
        [self.playerView.player pause];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)commentAction:(id)sender {
    if ([AVUser currentUser]) {
        AVObject *comment = [AVObject objectWithClassName:@"Comment"];
        [comment setObject:[AVUser currentUser] forKey:@"user"];
        [comment setObject:self.comment.text forKey:@"title"];
        [comment setObject:self.videoClassifyId forKey:@"videoClassifyId"];
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                [MBProgressHUD showSuccess:@"评论成功"];
                self.comment.text = @"";
            }
        }];
    }else{
        LoginTableVC *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginTableVC"];
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    if (self.commentArray.count) {
        cell.model = [self.commentArray objectAtIndex:indexPath.row];
    }
    return cell;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
#import "NSString+Time.h"

@implementation CommentCell
-(void)setModel:(CommentModel *)model{
    _model = model;
    self.title.text = model.title;
    self.userName.text = model.user.username;
    self.commentDate.text = [NSString compareCurrentTime:model.createdAt];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.user.imageUrl]];
    if ([model.user.sex isEqualToString:@"男"]) {
        self.userSex.image = [UIImage imageNamed:@"man"];
    }else{
        self.userSex.image = [UIImage imageNamed:@"girl"];
    }
}

@end
