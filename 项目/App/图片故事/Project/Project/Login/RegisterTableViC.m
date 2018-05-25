//
//  RegisterTableViC.m
//  Project
//
//  Created by masha on 2018/5/19.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "RegisterTableViC.h"
#import "SVProgressHUD.h"
//#import <SMS_SDK/SMSSDK.h>
#import <AVOSCloud/AVOSCloud.h>
#import "UserMessageTableVC.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface RegisterTableViC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;

@end

@implementation RegisterTableViC

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
//    [AVSMS requestShortMessageForPhoneNumber:@"13577778888" options:nil callback:^(BOOL succeeded, NSError * _Nullable error) {
//        // 发送失败可以查看 error 里面提供的信息
//    }];
//    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:@"13577778888" smsCode:@"123456" block:^(AVUser *user, NSError *error) {
//        // 如果 error 为空就可以表示登录成功了，并且 user 是一个全新的用户
//    }];
    
    if ([self judgePhoneNumber:self.phoneNumber.text]) {
        [AVSMS requestShortMessageForPhoneNumber:self.phoneNumber.text options:nil callback:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                //调用成功
                [self openCountdown];

            }else{
                [SVProgressHUD showErrorWithStatus:@"短信发送失败"];

            }
        }];
        
        /*[SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumber.text zone:@"86"  result:^(NSError *error) {
            
            if (!error){
                // 请求成功
                [self openCountdown];
                
            }else{
                // error
                [SVProgressHUD showErrorWithStatus:@"！"];
            }
        }];*/
    }
   
    
}
// 开启倒计时效果
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

- (IBAction)next:(UIButton *)sender {
    if ([self judgePhoneNumber:self.phoneNumber.text]) {
        if (self.verificationCode.text.length) {
              [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:self.phoneNumber.text smsCode:self.verificationCode.text block:^(AVUser *user, NSError *error) {
                if(user){
                    //验证成功
                    // 验证成功
                    UserMessageTableVC *VC =  [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"UserMessageTableVC"];
                    VC.phone = self.phoneNumber.text;
                    [self.navigationController pushViewController:VC animated:YES];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:@"验证码错误！"];

                }
            }];
            /*[SMSSDK commitVerificationCode:self.verificationCode.text phoneNumber:self.phoneNumber.text zone:@"86" result:^(NSError *error) {
                if (!error){
                    // 验证成功
                    UserMessageTableVC *VC =  [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"UserMessageTableVC"];
                    VC.phone = self.phoneNumber.text;
                    [self.navigationController pushViewController:VC animated:YES];
    
                }else{
                    [SVProgressHUD showErrorWithStatus:@"验证码错误！"];
                    // error
                }
            }];*/
        }
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
