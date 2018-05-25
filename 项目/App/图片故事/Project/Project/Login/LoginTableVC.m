//
//  LoginTableVC.m
//  Project
//
//  Created by masha on 2018/5/19.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "LoginTableVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"

@interface LoginTableVC ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;


@end

@implementation LoginTableVC

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

- (IBAction)login:(id)sender {
    if ([self judgePhoneNumber:self.phone.text withPassWord:self.password.text]) {
        [AVUser logInWithMobilePhoneNumberInBackground:self.phone.text password:self.password.text block:^(AVUser *user, NSError *error) {
            if (user && !error) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"登陆失败"];
            }
        }];
    }
}


- (BOOL)judgePhoneNumber:(NSString *)phoneUnmer withPassWord:(NSString *)passowd{
    if (phoneUnmer.length != 11){
        [SVProgressHUD showErrorWithStatus:@"请输入11位大陆手机号码！"];
        return NO;
    }
    if (passowd.length<6) {
        [SVProgressHUD showErrorWithStatus:@"请输入6位以上密码！"];
        return NO;
    }
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:phoneUnmer]) {
        return YES;
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入大陆合法手机号码！"];
        return NO;
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
