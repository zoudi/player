//
//  BaseViewController.m
//  majia
//
//  Created by pg on 2018/5/10.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon"] style: UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@implementation BaseTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon"] style: UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
