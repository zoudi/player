//
//  TopicMessageVC.m
//  football
//
//  Created by masha on 2018/5/29.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "TopicMessageVC.h"
#import "InvitationModel.h"
#import "UIImageView+WebCaChe.h"
#import <AVOSCloud/AVOSCloud.h>
#import "NSString+Time.h"
#import "MBProgressHUD+ZD.h"
#import "LoginTableVC.h"
#import "CommentModel.h"
#import "UserModel.h"
#import "ZDMoviePlayerController.h"
#import "PSTAlertController.h"
#import "MJRefresh.h"

@interface TopicMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *topicText;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIImageView *sex;
@property (weak, nonatomic) IBOutlet UITextField *comment;

@property (nonatomic, strong)NSMutableArray *commentArray;
@property (weak, nonatomic) IBOutlet UITableView *commentTabView;

@end

@implementation TopicMessageVC
- (NSMutableArray *)commentArray{
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (_model) {
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:[_model.user objectForKey:@"imageUrl"]]];
        self.userName.text = [_model.user objectForKey:@"username"];
        self.date.text = [NSString compareCurrentTime:_model.date];
        self.topicText.text = _model.title;
        self.location.text = _model.locationName;
        if ([[_model.user objectForKey:@"sex"] isEqualToString:@"男"]) {
            self.sex.image = [UIImage imageNamed:@"man"];
        }else{
            self.sex.image = [UIImage imageNamed:@"girl"];
        }
    }
    [self addFooter];
    [self addHeader];
//    [self lodMessge];
    // Do any additional setup after loading the view.
}
#pragma mark - 刷新加载
- (void)addHeader
{
    __weak typeof(self) vc = self;
    // 添加下拉刷新头部控件
    
    self.commentTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.commentArray removeAllObjects];
        [self addMessageWith:0];
//        [vc.commentTabView reloadData];
        // 结束刷新
        [vc.commentTabView.mj_footer resetNoMoreData];
        [vc.commentTabView.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [self.commentTabView.mj_header beginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) vc = self;
    
    // 添加上拉刷新尾部控件
    self.commentTabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self addMessageWith:self.commentArray.count];
//        [vc.commentTabView reloadData];
        // 结束刷新
        [vc.commentTabView.mj_footer endRefreshing];
    }];
}

-  (void)addMessageWith:(NSInteger)skip{
    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
    [query whereKey:@"topicId" equalTo:self.model.topicId];
    [query whereKey:@"type" equalTo:@"topic"];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    query.limit = 10;
    if (skip) {
        query.skip = skip;
    }else{
        query.skip = 0;
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count == 0) {
            [self.commentTabView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.commentTabView.mj_footer resetNoMoreData];
        }
        for (AVObject *obj in objects) {
            CommentModel *comment = [[CommentModel alloc] init];
            comment.title = [obj objectForKey:@"title"];
            comment.videoClassifyId = [obj objectForKey:@"topicId"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)community:(id)sender {
    if ([AVUser currentUser]) {
        AVObject *comment = [AVObject objectWithClassName:@"Comment"];
        [comment setObject:[AVUser currentUser] forKey:@"user"];
        [comment setObject:@"topic" forKey:@"type"];
        [comment setObject:self.comment.text forKey:@"title"];
        [comment setObject:self.model.topicId forKey:@"topicId"];
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                [MBProgressHUD showSuccess:@"评论成功"];
                [self addMessageWithObject:comment];
                self.comment.text = @"";
            }
        }];
    }else{
        LoginTableVC *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginTableVC"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)addMessageWithObject:(AVObject *)obj{
    CommentModel *comment = [[CommentModel alloc] init];
    comment.title = [obj objectForKey:@"title"];
    comment.videoClassifyId = [obj objectForKey:@"topicId"];
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
    [self.commentArray insertObject:comment atIndex:0];
   
    [self.commentTabView insertRowsAtIndexPaths: @[ [NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    
}

- (IBAction)report:(id)sender {
    AVObject *report = [AVObject objectWithClassName:@"report"];
    [report setObject:self.model.topicId forKey:@"topicId"];
    PSTAlertController *alert= [PSTAlertController alertControllerWithTitle:@"举报理由" message:@"" preferredStyle:PSTAlertControllerStyleAlert ];
    [alert addAction:[PSTAlertAction actionWithTitle:@"色情内容" handler:^(PSTAlertAction * _Nonnull action) {
        [report setObject:@"1" forKey:@"type"];
        [report saveInBackground];
        [MBProgressHUD showSuccess:@"举报成功"];
        
    }]];
    [alert addAction:[PSTAlertAction actionWithTitle:@"广告骚扰" handler:^(PSTAlertAction * _Nonnull action) {
        [report setObject:@"2" forKey:@"type"];
        [report saveInBackground];
        [MBProgressHUD showSuccess:@"举报成功"];
        
    }]];
    [alert addAction:[PSTAlertAction actionWithTitle:@"金钱欺骗" handler:^(PSTAlertAction * _Nonnull action) {
        [report setObject:@"3" forKey:@"type"];
        [report saveInBackground];
        [MBProgressHUD showSuccess:@"举报成功"];
        
    }]];
    [alert addAction:[PSTAlertAction actionWithTitle:@"谩骂诽谤" handler:^(PSTAlertAction * _Nonnull action) {
        [report setObject:@"4" forKey:@"type"];
        [report saveInBackground];
        [MBProgressHUD showSuccess:@"举报成功"];
        
    }]];
    [alert addAction:[PSTAlertAction actionWithTitle:@"其他" handler:^(PSTAlertAction * _Nonnull action) {
        [report setObject:@"5" forKey:@"type"];
        [report saveInBackground];
        [MBProgressHUD showSuccess:@"举报成功"];
        
    }]];
    
    [alert addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleDestructive handler:nil]];
    [alert showWithSender:nil controller:self animated:YES completion:nil];
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

@implementation TopicCommunityCell

@end
