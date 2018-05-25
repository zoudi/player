//
//  ImageStoryVC.m
//  majia
//
//  Created by pg on 2018/5/10.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "ImageStoryVC.h"
#import "HomeTabVC.h"
#import "PictureStoryModel.h"
#import "UIImageView+WebCache.h"
#import "StoryModel.h"
#import "AuthorVC.h"
#import "AuthorModel.h"
#import "MJPhotoBrowser.h"
#import "DataBase.h"
#import "PSTAlertController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"

@interface ImageStoryVC ()
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;
@property (strong, nonatomic) IBOutlet UILabel *avatarName;
@property (strong, nonatomic) IBOutlet UILabel *publishDate;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *collect;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *action;

@end

@implementation ImageStoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.pictureStoryModel) {
        self.pictureStoryModel = self.pictureStoryModel;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setPictureStoryModel:(PictureStoryModel *)pictureStoryModel {
    _pictureStoryModel = pictureStoryModel;
    NSString *colorStr = [NSString stringWithFormat:@"0x%@",self.pictureStoryModel.img_color];
    unsigned long color = strtoul([colorStr UTF8String],0,0);
//    self.picImageView.backgroundColor = UIColorFromRGB(color);
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.pictureStoryModel.thumb] placeholderImage:[[UIImage alloc] init]];
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.pictureStoryModel.avatar] placeholderImage:[[UIImage alloc] init]];
    [self.avatarName setText:self.pictureStoryModel.user_name];
    [self.publishDate setText:self.pictureStoryModel.created];
    [self.location setText:self.pictureStoryModel.story_detail.location];
    
    if (self.pictureStoryModel.story_detail.story) {
        NSString *str = [NSString stringWithFormat:@"图片故事：%@ - %@",self.pictureStoryModel.story_detail.story,self.pictureStoryModel.story_detail.author];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:4];
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
        self.titleLabel.attributedText = text;
    }
    if (self.pictureStoryModel.isAttention) {
        [self.collect setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [self.collect setTitle:@"+ 关注" forState:UIControlStateNormal];
    }
    if (self.pictureStoryModel.isCollect) {
        [self.action setTitle:@"取消收藏"];
    }else{
        [self.action setTitle:@"收藏"];

    }
    
    
}
- (IBAction)showOriginalImageView:(id)sender {
//- (void)showOriginalImageView {
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    MJPhoto *photo = ({
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:self.pictureStoryModel.thumb];
        photo.srcImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        photo;
    });
    photoBrowser.photos = @[photo];
    photoBrowser.currentPhotoIndex = 0;
    [photoBrowser show];
}

- (IBAction)showImageView:(id)sender {
//- (void)showImageView:(UIButton *)sender {
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    MJPhoto *photo = ({
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:self.pictureStoryModel.full_res];
        photo.srcImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        photo;
    });
    photoBrowser.photos = @[photo];
    photoBrowser.currentPhotoIndex = 0;
    [photoBrowser show];
}

- (IBAction)collectAction:(UIBarButtonItem *)sender {
    if ([[DataBase sharedDataBase] pictureWithId:[NSString stringWithFormat:@"%@",self.pictureStoryModel.mID]]) {
        [[DataBase sharedDataBase] deletePicture:self.pictureStoryModel];
        [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
        self.pictureStoryModel.isCollect = NO;
    }else{
        [[DataBase sharedDataBase] addPicture:self.pictureStoryModel];
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        self.pictureStoryModel.isCollect = YES;
    }
    self.pictureStoryModel = self.pictureStoryModel;
    
}

- (IBAction)attentionAction:(UIButton *)sender {
    if ([[DataBase sharedDataBase] authorWithId:[NSString stringWithFormat:@"%@",_pictureStoryModel.user_id]]) {
        AuthorModel *authorModel = [[AuthorModel alloc] init];
        authorModel.mID = self.pictureStoryModel.user_id;
        authorModel.picture_url = self.pictureStoryModel.avatar;
        authorModel.user_name = self.pictureStoryModel.user_name;
        [[DataBase sharedDataBase] deleteAuthor:authorModel];
        _pictureStoryModel.isAttention = NO;
        [SVProgressHUD showSuccessWithStatus:@"取消关注"];
    }else{
        AuthorModel *authorModel = [[AuthorModel alloc] init];
        authorModel.mID = self.pictureStoryModel.user_id;
        authorModel.picture_url = self.pictureStoryModel.avatar;
        authorModel.user_name = self.pictureStoryModel.user_name;
        [[DataBase sharedDataBase] addAuthor:authorModel];
        _pictureStoryModel.isAttention = YES;
        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
    }
    self.pictureStoryModel = self.pictureStoryModel;
}
- (IBAction)reportAction:(UIButton *)sender {
    AVObject *report = [AVObject objectWithClassName:@"report"];
    [report setObject:self.pictureStoryModel.mID forKey:@"id"];
    PSTAlertController *alert= [PSTAlertController alertControllerWithTitle:@"举报理由" message:@"" preferredStyle:PSTAlertControllerStyleAlert ];
    [alert addAction:[PSTAlertAction actionWithTitle:@"骚然/色情内容" handler:^(PSTAlertAction * _Nonnull action) {
        [report setObject:@"1" forKey:@"type"];
        [report saveInBackground];
        [SVProgressHUD showSuccessWithStatus:@"举报成功"];

    }]];
    [alert addAction:[PSTAlertAction actionWithTitle:@"广告骚扰" handler:^(PSTAlertAction * _Nonnull action) {
        [report setObject:@"2" forKey:@"type"];
        [report saveInBackground];
        [SVProgressHUD showSuccessWithStatus:@"举报成功"];

    }]];
    [alert addAction:[PSTAlertAction actionWithTitle:@"金钱欺骗" handler:^(PSTAlertAction * _Nonnull action) {
        [report setObject:@"3" forKey:@"type"];
        [report saveInBackground];
        [SVProgressHUD showSuccessWithStatus:@"举报成功"];

    }]];
    [alert addAction:[PSTAlertAction actionWithTitle:@"谩骂诽谤" handler:^(PSTAlertAction * _Nonnull action) {
        [report setObject:@"4" forKey:@"type"];
        [report saveInBackground];
        [SVProgressHUD showSuccessWithStatus:@"举报成功"];

    }]];
    [alert addAction:[PSTAlertAction actionWithTitle:@"其他" handler:^(PSTAlertAction * _Nonnull action) {
        [report setObject:@"5" forKey:@"type"];
        [report saveInBackground];
        [SVProgressHUD showSuccessWithStatus:@"举报成功"];

    }]];
    
    [alert addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleDestructive handler:nil]];
    [alert showWithSender:nil controller:self animated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushUser"]) {
        AuthorVC *VC =  segue.destinationViewController;
        AuthorModel *authorModel = [[AuthorModel alloc] init];
        authorModel.mID = self.pictureStoryModel.user_id;
        authorModel.picture_url = self.pictureStoryModel.avatar;
        authorModel.user_name = self.pictureStoryModel.user_name;
        VC.userMode = authorModel;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
