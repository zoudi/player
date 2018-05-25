//
//  AuthorTableViewController.m
//  majia
//
//  Created by masha on 2018/5/14.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "AuthorTableViewController.h"
#import "PictureStoryModel.h"
#import "ImageStoryVC.h"
#import "HomeTabVC.h"
#import "AuthorModel.h"
#import "ResolveData.h"
#import "AuthorVC.h"
#import "DataBase.h"
@interface ParentClassScrollViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ParentClassScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"goTop" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
}

-(void)acceptMsg:(NSNotification *)notification{
    
    NSString *notificationName = notification.name;
    
    if ([notificationName isEqualToString:@"goTop"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.scrollView.showsVerticalScrollIndicator = YES;
        }
    } else if([notificationName isEqualToString:@"leaveTop"]){
        self.scrollView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }

    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil userInfo:@{@"canScroll":@"1"}];
    }
    _scrollView = scrollView;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.scrollView.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
@interface AuthorTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *defaultView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AuthorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    
    [self handleData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --  数据处理
- (void)handleData {
    //防止block循环引用
    __weak typeof(self) weakSelf = self;
    
    NSString *url;
    if (self.type == 1) {
        url = [NSString stringWithFormat:@"palette/get_img_by_user_id/%@",self.authorModel.mID];
    } else {
        url = [NSString stringWithFormat:@"collections/get_entries_by_user_id/%@",self.authorModel.mID];
    }
    [ResolveData resolveDataWithUrlStr:url setHTTPMethod:@"GET" postBody:nil resolveBlock:^(id obj) {
        NSDictionary *tempDict = (NSDictionary *)obj;
//        NSLog(@"%@",tempDict);
        [weakSelf.dataArray removeAllObjects];
        if ([[tempDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in [tempDict objectForKey:@"data"]) {
                PictureStoryModel *pictureStoryModel = [[PictureStoryModel alloc] init];
                [pictureStoryModel setValuesForKeysWithDictionary:dict];
                pictureStoryModel.user_name = weakSelf.authorModel.user_name;
                if ([[DataBase sharedDataBase] pictureWithId:[NSString stringWithFormat:@"%@",pictureStoryModel.mID]]) {
                    pictureStoryModel.isCollect = YES;
                }
                if ([[DataBase sharedDataBase] authorWithId:[NSString stringWithFormat:@"%@",pictureStoryModel.user_id]]) {
                    pictureStoryModel.isAttention = YES;
                }
                [weakSelf.dataArray addObject:pictureStoryModel];
            }
        }
        [weakSelf.tableView reloadData];
    } failureBlock:^(id obj) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        [self addDefaultView];
    }
    else
    {
        [_defaultView removeFromSuperview];
    }
    return self.dataArray.count;
}

- (void)addDefaultView
{
    [_defaultView removeFromSuperview];
    _defaultView = nil;
    _defaultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 51)];
    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 51)];
    defaultLabel.font = [UIFont systemFontOfSize:13.0f];
    defaultLabel.textAlignment = NSTextAlignmentCenter;
    defaultLabel.textColor = [UIColor grayColor];
    
    defaultLabel.text = @"还没有任何作品哦";
    
    [_defaultView addSubview:defaultLabel];
    
    [self.tableView addSubview:_defaultView];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageItemCell" forIndexPath:indexPath];
    if (self.dataArray.count) {
        cell.pictureStoryModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    [cell setTapClick:^(id sender) {
        [self showAuthor:indexPath];
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)showAuthor:(NSIndexPath *)indexPath {
    PictureStoryModel *pictureStoryModel = [self.dataArray objectAtIndex:indexPath.row];
    AuthorVC *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthorVC"];
    AuthorModel *authorModel = [[AuthorModel alloc] init];
    authorModel.mID = pictureStoryModel.user_id;
    authorModel.picture_url = pictureStoryModel.avatar;
    authorModel.user_name = pictureStoryModel.user_name;
    VC.userMode = authorModel;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    PictureStoryModel *pictureStoryModel = [self.dataArray objectAtIndex:indexPath.row];
    if ([segue.identifier isEqualToString:@"pushImage"]) {
        ImageStoryVC *VC =  segue.destinationViewController;
        VC.pictureStoryModel = pictureStoryModel;
    }/*else if ([segue.identifier isEqualToString:@"pushUser"]){
        AuthorVC *VC =  segue.destinationViewController;
        AuthorModel *authorModel = [[AuthorModel alloc] init];
        authorModel.mID = pictureStoryModel.user_id;
        authorModel.picture_url = pictureStoryModel.avatar;
        authorModel.user_name = pictureStoryModel.user_name;
        VC.userMode = authorModel;
    }*/
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
