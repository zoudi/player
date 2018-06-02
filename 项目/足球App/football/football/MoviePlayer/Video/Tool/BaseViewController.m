//
//  BaseViewController.m
//  football
//
//  Created by masha on 2018/5/29.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon"] style: UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backButtonItem.tintColor = [UIColor blackColor];
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


@end

@implementation BaseTabLeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backIcon"] style: UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
