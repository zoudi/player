//
//  HotSaleController.h
//  majia
//
//  Created by masha on 2018/5/14.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotSaleController : UIViewController
@property (nonatomic,strong) IBOutlet UIScrollView *segmentScrollV;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *centreButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic,strong) UIButton *seleBtn;
@property (strong, nonatomic) IBOutlet UIView *segmentView;
@property (strong, nonatomic) UIView *line;
@end
