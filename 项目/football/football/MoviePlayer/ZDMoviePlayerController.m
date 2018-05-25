//
//  ZDMoviePlayerController.m
//  football
//
//  Created by masha on 2018/5/25.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "ZDMoviePlayerController.h"
#import "YGPlayerView.h"
//#import "YGVideoTool.h"
#import "CourseModel.h"

@interface ZDMoviePlayerController ()
@property (weak, nonatomic) IBOutlet YGPlayerView *playerView;

@end

@implementation ZDMoviePlayerController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPlayerView];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning-------");
}

// 初始化播放器View
- (void)setupPlayerView
{
    YGPlayInfo *playInfo = [self.dataArray objectAtIndex:self.index];
    [self.playerView playWithPlayInfo:playInfo];
    [self.playerView setPlayInfos:self.dataArray];
}

- (IBAction)backAction:(id)sender {
    if (self.playerView.isLandscape) { // 转至竖屏
        [self.playerView setForceDeviceOrientation:UIDeviceOrientationPortrait];
    }else{
        [self.playerView.player pause];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
