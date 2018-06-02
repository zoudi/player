//
//  MineTableViewController.m
//  football
//
//  Created by masha on 2018/5/25.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "MineTableViewController.h"
#import "PSTAlertController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoginTableVC.h"
#import "UIImageView+WebCache.h"
#import "UserMessageTableVC.h"

@interface MineTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userSex;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UILabel *login;

@end

@implementation MineTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshUser];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshUser{
    if ([AVUser currentUser]) {
        AVUser *user = [AVUser currentUser];
        self.userName.text = [user objectForKey:@"username"];
        self.signature.text = [user objectForKey:@"signature"];
        if ([[user objectForKey:@"sex"] isEqualToString:@"男"]) {
            self.userSex.image = [UIImage imageNamed:@"man"];
        }else{
            self.userSex.image = [UIImage imageNamed:@"girl"];
        }
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"imageUrl"]]];
        self.login.text = @"退出登陆";
    }else{
        self.userName.text = @"";
        self.signature.text = @"";
        self.userImage.image = [UIImage imageNamed:@"user_default"];
        self.userSex.image = [[UIImage alloc]init];
        self.login.text = @"登陆";
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if ([AVUser currentUser]) {
            UserMessageTableVC *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"UserMessageTableVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self logOut];
        }
    }else if (indexPath.section == 2){
        [self logOut];
    }
}

- (void)logOut{
    if ([AVUser currentUser]) {
        PSTAlertController *alert = [PSTAlertController alertControllerWithTitle:@"退出登陆" message:@"" preferredStyle:PSTAlertControllerStyleAlert];
        [alert addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleDefault handler:nil]];
        [alert addAction:[PSTAlertAction actionWithTitle:@"确认" style:PSTAlertActionStyleDefault handler:^(PSTAlertAction * _Nonnull action) {
            [AVUser  logOut];
            [self refreshUser];
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    }else{
        LoginTableVC *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginTableVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
