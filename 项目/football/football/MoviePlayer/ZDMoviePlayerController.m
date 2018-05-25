//
//  ZDMoviePlayerController.m
//  football
//
//  Created by masha on 2018/5/25.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "ZDMoviePlayerController.h"
#import "YGPlayerView.h"
#import "YGVideoTool.h"
#import "YGPlayInfo.h"
@interface ZDMoviePlayerController ()
@property (nonatomic, strong) NSMutableArray *playInfos;
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
- (NSMutableArray *)playInfos
{
    if (_playInfos == nil) {
        _playInfos = [YGVideoTool playInfos];
    }
    return _playInfos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPlayerView];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning-------");
}

// 初始化播放器View
- (void)setupPlayerView
{
//    YGPlayerView *playerView = [[[NSBundle mainBundle] loadNibNamed:@"YGPlayerView" owner:nil options:nil] lastObject];
//    [self.view addSubview:playerView];
    YGPlayInfo *playInfo = [self.playInfos firstObject];
    [self.playerView playWithPlayInfo:playInfo];
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
