//
//  AuthorVC.m
//  majia
//
//  Created by pg on 2018/5/11.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "AuthorVC.h"
#import "HomeTabVC.h"
#import "UIImageView+WebCache.h"
#import "AuthorTableViewController.h"
#import "AuthorModel.h"
#define UI_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface AuthorVC ()
@property (strong, nonatomic) IBOutlet AuthorHeaderView *headView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;


@end

@implementation AuthorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.userMode.user_name;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.headView.authorModel = self.userMode;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    
}

- (void)acceptMsg:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ([[UIScreen mainScreen] bounds].size.height) - 64;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedImageA"]) {
        NSLog(@"A");
        AuthorTableViewController *VC = segue.destinationViewController;
        VC.type = 1;
        VC.authorModel = self.userMode;
    }else if ([segue.identifier isEqualToString:@"embedImageB"]){
        AuthorTableViewController *VC = segue.destinationViewController;
        VC.type = 2;
        VC.authorModel = self.userMode;
        NSLog(@"B");
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     * 处理联动
     */
     //获取滚动视图y值的偏移量
     CGFloat tabOffsetY = [self.tableView rectForSection:0].origin.y;
     CGFloat offsetY = scrollView.contentOffset.y;
     
     _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
     if (offsetY >= tabOffsetY) {
         scrollView.contentOffset = CGPointMake(0, tabOffsetY);
     _isTopIsCanNotMoveTabView = YES;
     }else{
         _isTopIsCanNotMoveTabView = NO;
     }
     if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
         if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
             //NSLog(@"滑动到顶端");
             [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
             _canScroll = NO;
         }
         if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
             //NSLog(@"离开顶端");
             if (!_canScroll) {
                 scrollView.contentOffset = CGPointMake(0, tabOffsetY);
             }
         }
     }
     
     [self.headView scrollViewDidScroll:scrollView];
     }

@end

#import "AuthorModel.h"
@implementation AuthorHeaderView
- (void)setAuthorModel:(AuthorModel *)authorModel {
    _authorModel = authorModel;
    [self.avatarImv sd_setImageWithURL:[NSURL URLWithString:self.authorModel.picture_url] placeholderImage:[UIImage imageNamed:@"bg"]];
    self.nameLabel.text = self.authorModel.user_name;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if(y <= 0) {
        CGRect visFrame = self.bannerView.frame;
        visFrame.origin.y = y;
        visFrame.size.height = 180 - y;
        self.bannerView.frame = visFrame;
    }
}
@end

@implementation MYSegmentView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self addView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addView];
    }
    return self;
}
- (void)addView{
    self.line = [[UILabel alloc]initWithFrame:CGRectMake((UI_SCREEN_WIDTH/2 - UI_SCREEN_WIDTH / 3)/2,44, UI_SCREEN_WIDTH / 3, 1)];
    self.line.backgroundColor = [UIColor redColor];//UIColorFromRGB(0x515151);
    [self.segmentView addSubview:self.line];
    self.seleBtn.selected = YES;
    self.seleBtn = self.leftButton;
    self.rightButton.selected = NO;
}

- (IBAction)buttonScrollAction:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint frame = self.line.center;
        frame.x = [UIScreen mainScreen].bounds.size.width/(2 * 2) +([UIScreen mainScreen].bounds.size.width/2) * (sender.tag);
        self.line.center = frame;
    }];
    
    self.seleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];;
    self.seleBtn.selected = NO;
    self.seleBtn = sender;
    self.seleBtn.selected = YES;
    self.seleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.segmentScrollV setContentOffset:CGPointMake((sender.tag) * self.frame.size.width, 0) animated:YES ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectVC" object:sender userInfo:nil];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint frame = self.line.center;
        frame.x = self.frame.size.width/(2*2) + (self.frame.size.width/2) * (self.segmentScrollV.contentOffset.x/self.frame.size.width);
        self.line.center = frame;
    }];
    UIButton *btn = (UIButton*)[self.segmentView viewWithTag:(self.segmentScrollV.contentOffset.x/self.frame.size.width)];
    self.seleBtn.selected = NO;
    self.seleBtn = btn;
    self.seleBtn.selected = YES;
}
@end

