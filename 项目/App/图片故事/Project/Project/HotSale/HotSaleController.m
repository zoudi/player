//
//  HotSaleController.m
//  majia
//
//  Created by masha on 2018/5/14.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "HotSaleController.h"
#import "AuthorViewController.h"
#define UI_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface HotSaleController ()<UIScrollViewDelegate>

@end

@implementation HotSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.line = [[UILabel alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH/3 - UI_SCREEN_WIDTH / 4)/2,50, UI_SCREEN_WIDTH / 4, 1)];
    self.line.backgroundColor = [UIColor redColor];//UIColorFromRGB(0x515151);
    [self.segmentView addSubview:self.line];
    self.seleBtn.selected = YES;
    self.seleBtn = self.leftButton;
    self.rightButton.selected = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonScrollAction:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint frame = self.line.center;
        frame.x = [UIScreen mainScreen].bounds.size.width/(3 * 2) +([UIScreen mainScreen].bounds.size.width/3) * (sender.tag);
        self.line.center = frame;
    }];
    
    self.seleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];;
    self.seleBtn.selected = NO;
    self.seleBtn = sender;
    self.seleBtn.selected = YES;
    self.seleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.segmentScrollV setContentOffset:CGPointMake((sender.tag) * UI_SCREEN_WIDTH, 0) animated:YES ];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint frame = self.line.center;
        frame.x = UI_SCREEN_WIDTH/(3*2) + (UI_SCREEN_WIDTH/3) * (self.segmentScrollV.contentOffset.x/UI_SCREEN_WIDTH);
        self.line.center = frame;
    }];
    UIButton *btn = (UIButton*)[self.segmentView viewWithTag:(self.segmentScrollV.contentOffset.x/UI_SCREEN_WIDTH)];
    self.seleBtn.selected = NO;
    self.seleBtn = btn;
    self.seleBtn.selected = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"emberA"]) {
        AuthorViewController *VC = segue.destinationViewController;
        VC.type = 1;
    }else if ([segue.identifier isEqualToString:@"emberB"]){
        AuthorViewController *VC = segue.destinationViewController;
        VC.type = 2;
    }else if ([segue.identifier isEqualToString:@"emberC"]){
        AuthorViewController *VC = segue.destinationViewController;
        VC.type = 3;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
