//
//  YGPlayerView.h
//  Demo
//
//  Created by LiYugang on 2018/3/5.
//  Copyright © 2018年 LiYugang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class YGPlayInfo;

@interface YGPlayerView : UIView
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSMutableArray *playInfos;
@property (nonatomic, assign, getter=isLandscape) BOOL landscape;
- (void)playWithPlayInfo:(YGPlayInfo *)playInfo;
- (void)setForceDeviceOrientation:(UIDeviceOrientation)deviceOrientation;
- (void)resetPlayer;
@end
