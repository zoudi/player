//
//  MBProgressHUD+ZD.h
//  football
//
//  Created by masha on 2018/5/25.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZD)
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
