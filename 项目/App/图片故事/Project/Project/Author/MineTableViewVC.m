//
//  MineTableViewVC.m
//  Project
//
//  Created by masha on 2018/5/17.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "MineTableViewVC.h"
#import "SDImageCache.h"
#import "LoginTableVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIImageView+WebCache.h"
#import "UserMessageTableVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "PSTAlertController.h"

@interface MineTableViewVC ()
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

@end

@implementation MineTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCacheSize];
    
}
- (void)getCacheSize{
    NSUInteger tmpSize = [[SDImageCache sharedImageCache] getSize];
    if (tmpSize >= 1024*1024*1024) {
        self.cacheLabel.text = [NSString stringWithFormat:@"%0.2f G",tmpSize /(1024.f*1024.f*1024.f)];
    }else if (tmpSize >= 1024*1024) {
        self.cacheLabel.text = [NSString stringWithFormat:@"%0.2f M",tmpSize /(1024.f*1024.f)];
    }else{
        self.cacheLabel.text = [NSString stringWithFormat:@"%0.2f K",tmpSize / 1024.f];
    }
    if ([AVUser currentUser]) {
        AVUser *user = [AVUser currentUser];
        if (user.username) {
            self.userName.text = user.username;
            [self.userImage sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"imageUrl"]] placeholderImage:[[UIImage alloc]init] ];
        }
        [self.logOutButton setTitle:@"退出登陆" forState:UIControlStateNormal];

    }else{
        self.userName.text = @"请登陆";
        self.userImage.image = [UIImage imageNamed:@"user_default"];
        [self.logOutButton setTitle:@"登陆" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if ([AVUser currentUser]) {
            UserMessageTableVC *VC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"UserMessageTableVC"];
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            //判断是否登陆
            LoginTableVC *VC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginTableVC"];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else if (indexPath.section == 4) {
//        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];//可有可无
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [self getCacheSize];
        }];
    }
}
- (IBAction)logOut:(UIButton *)sender {
//    [[AVUser currentUser] logOut];
    if ([AVUser currentUser]) {
        PSTAlertController *alert= [PSTAlertController alertControllerWithTitle:@"退出登录" message:@"" preferredStyle:PSTAlertControllerStyleAlert ];
        [alert addAction:[PSTAlertAction actionWithTitle:@"确认" handler:^(PSTAlertAction * _Nonnull action) {
            [AVUser logOut];
            [self getCacheSize];
        }]];
    
        [alert addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleDestructive handler:nil]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
        
    }else{
       
        LoginTableVC *VC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginTableVC"];
        [self.navigationController pushViewController:VC animated:YES];
    }

}



@end
