//
//  FindPasswordTableViC.m
//  Project
//
//  Created by masha on 2018/5/19.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "FindPasswordTableViC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FindPasswordTableViC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;
@end

@implementation FindPasswordTableViC

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
- (IBAction)getCode:(UIButton *)sender {
    if ([self judgePhoneNumber:self.phoneNumber.text]) {
        [AVUser requestPasswordResetWithPhoneNumber:self.phoneNumber.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                [self openCountdown];

            } else {
                [SVProgressHUD showErrorWithStatus:@"发送失败"];

            }
        }];
    }
}
- (BOOL)judgePhoneNumber:(NSString *)phoneUnmer {
    if (phoneUnmer.length != 11){
        [SVProgressHUD showErrorWithStatus:@"请输入11位大陆手机号码！"];
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
-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.authCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.authCodeBtn setTitleColor:UIColorFromRGB(0xFB8557) forState:UIControlStateNormal];
                self.authCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.authCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.authCodeBtn setTitleColor:UIColorFromRGB(0x979797) forState:UIControlStateNormal];
                self.authCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)modificationPassword:(id)sender {
    if (self.password.text.length<6) {
        [SVProgressHUD showErrorWithStatus:@"请输入六位以上密码"];

    }else{
    [AVUser resetPasswordWithSmsCode:self.verificationCode.text newPassword:self.password.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"修改失败"];
            NSLog(@"====%@",error);
        }
    }];
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
