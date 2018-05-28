//
//  UserMessageTableVC.m
//  Project
//
//  Created by masha on 2018/5/19.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "UserMessageTableVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "PSTAlertController.h"
#import "MBProgressHUD+ZD.h"
#import "LoginTableVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIImageView+WebCache.h"
#import "SelectDateVC.h"
#import "UITextView+WZB.h"

@interface UserMessageTableVC ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userSex;
@property (weak, nonatomic) IBOutlet UITextField *userBirthday;
@property (weak, nonatomic) IBOutlet UITextView *userSignature;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (nonatomic) BOOL imageBool;
@end

@implementation UserMessageTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([AVUser currentUser]) {
        AVUser *user = [AVUser currentUser];
        if (user.username) {
            self.userName.text = user.username;
        }
        if ([user objectForKey:@"sex"]) {
            self.userSex.text = [user objectForKey:@"sex"];
        }
        if ([user objectForKey:@"birthday"]) {
            self.userBirthday.text = [user objectForKey:@"birthday"];
        }
        if ([user objectForKey:@"signature"]) {
            self.userSignature.text = [user objectForKey:@"signature"];
        }
        if ([user objectForKey:@"imageUrl"]) {
            [self.userImage sd_setImageWithURL:[user objectForKey:@"imageUrl"] placeholderImage:[[ UIImage alloc]init]];
        }
        
    }
    self.userSignature.wzb_placeholder = @"请填写个性签名";
    self.userSignature.wzb_placeholderColor = [UIColor lightGrayColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addUserImage:(UITapGestureRecognizer *)sender {
    [MBProgressHUD showError:@"头像上传功能暂未开放！"];
    /*
    PSTAlertController *alert= [PSTAlertController alertControllerWithTitle:@"上传头像" message:@"请选择需要上传的头像" preferredStyle:PSTAlertControllerStyleActionSheet ];
    [alert addAction:[PSTAlertAction actionWithTitle:@"拍照" handler:^(PSTAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES; //可编辑
        //判断是否可以打开照相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            NSLog(@"没有摄像头");
        }
    }]];
    
    [alert addAction:[PSTAlertAction actionWithTitle:@"选择照片" handler:^(PSTAlertAction * _Nonnull action) {
        // 进入相册
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:^{
                NSLog(@"打开相册");
            }];
        }else{
            NSLog(@"不能打开相册");
        }
    }]];
    [alert addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:nil]];
    
    [alert showWithSender:nil controller:self animated:YES completion:nil];*/
}
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    NSLog(@"finish..");
    if(image){
        self.userImage.image = image;
        self.imageBool = YES;
    }
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        //图片存入相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}*/

- (IBAction)save:(id)sender {
//    if (self.imageBool) {
//
//    }
    AVUser *user = [AVUser currentUser];
    if ([user objectForKey:@"pass"]) {
        
        if (self.userName.text) {
            user.username = self.userName.text;
        }
        if (self.userSex.text) {
            [user setObject:self.userSex.text forKey:@"sex"];
        }
        if (self.userBirthday.text) {
            [user setObject:self.userBirthday.text forKey:@"birthday"];
        }
        if (self.userSignature.text) {
            [user setObject:self.userSignature.text forKey:@"signature"];
        }
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                [MBProgressHUD showSuccess:@"修改成功"];
            }else{
                [MBProgressHUD showError:@"修改失败"];
            }
        }];
    }else{
        PSTAlertController *alert= [PSTAlertController alertControllerWithTitle:@"设置密码" message:@"请输入密码" preferredStyle:PSTAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        }];
        [alert addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:nil]];
        [alert addAction:[PSTAlertAction actionWithTitle:@"确认" handler:^(PSTAlertAction * _Nonnull action) {
            UITextField *textF = [alert.textFields objectAtIndex:0];
            [self registerUserWithpassword:textF.text];
        }]];
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    }
   
    
}

- (void)registerUserWithpassword:(NSString *)password{
     AVUser *user = [AVUser currentUser];
     if (self.userName.text) {
     user.username = self.userName.text;
     }
     if (self.userSex.text) {
     [user setObject:self.userSex.text forKey:@"sex"];
     }
     if (self.userBirthday.text) {
     [user setObject:self.userBirthday.text forKey:@"birthday"];
     }
     if (password) {
     user.password = password;
     [user setObject:password forKey:@"pass"];
     }
     if (self.userSignature.text) {
     [user setObject:self.userSignature.text forKey:@"signature"];
     }
     user.mobilePhoneNumber = self.phone;
     [user setObject:@"http://img.zcool.cn/community/01c75b57b32f650000018c1bad8228.png" forKey:@"imageUrl"];
     [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (succeeded) {
     // 注册成功
     [MBProgressHUD showError:@"注册成功"];
     for (UIViewController *vc in self.navigationController.viewControllers) {
         if ([vc isKindOfClass:[LoginTableVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
         }
     }
     
     } else {
     NSLog(@"%@",error);
     // 失败的原因可能有多种，常见的是用户名已经存在。
     }
     }];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        PSTAlertController *alert= [PSTAlertController alertControllerWithTitle:@"选择性别" message:@"" preferredStyle:PSTAlertControllerStyleActionSheet ];
        [alert addAction:[PSTAlertAction actionWithTitle:@"男" handler:^(PSTAlertAction * _Nonnull action) {
            self.userSex.text = @"男";
        }]];
        [alert addAction:[PSTAlertAction actionWithTitle:@"女" handler:^(PSTAlertAction * _Nonnull action) {
            self.userSex.text = @"女";
        }]];
        
        [alert addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleDestructive handler:nil]];
        
        [alert showWithSender:nil controller:self animated:YES completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"pushDate"]){
        SelectDateVC *VC = segue.destinationViewController;
        if(self.userBirthday.text.length){
            VC.dateStr = self.userBirthday.text;

        }else{
            VC.dateStr = @"2000-01-01";

        }
        [VC setDateBlock:^(NSString *strValue) {
            self.userBirthday.text = strValue;
        }];
    }
}


@end
