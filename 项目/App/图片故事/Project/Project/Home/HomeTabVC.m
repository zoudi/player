//
//  HomeTabVC.m
//  majia
//
//  Created by pg on 2018/5/10.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "HomeTabVC.h"
#import "MJRefresh.h"
//#import "AFNetworking.h"
#import "ResolveData.h"
#import "PictureStoryModel.h"
#import "UIImageView+WebCache.h"
#import "ImageStoryVC.h"
#import "AuthorVC.h"
#import "AuthorModel.h"
#import "AuthorVC.h"
#import "DataBase.h"
#import "SVProgressHUD.h"

#define UI_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface HomeTabVC ()
@property (nonatomic, assign) NSInteger pagenum;
@property (nonatomic, assign) NSInteger page_total;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *listDict;
@end

@implementation HomeTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 150;//估算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self addHeader];
    [self addFooter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 刷新加载
- (void)addHeader
{
    __weak typeof(self) vc = self;
    // 添加下拉刷新头部控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [vc p_getNum];
        [vc.tableView reloadData];
        // 结束刷新
        [vc.tableView.mj_footer resetNoMoreData];
        [vc.tableView.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)addFooter
{
    __weak typeof(self) vc = self;
    
    // 添加上拉刷新尾部控件
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (vc.pagenum == 0) {
            [vc.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [vc p_solveData:vc.pagenum];
            
            [vc.tableView reloadData];
            // 结束刷新
            [vc.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark -- 获得总页码
- (void)p_getNum {
    //防止block循环引用
    __weak typeof(self) weakSelf = self;
    
    NSString *url = @"collections/get_edition_num";

    [ResolveData resolveDataWithUrlStr:url setHTTPMethod:@"GET" postBody:nil resolveBlock:^(id obj) {
        NSDictionary *tempDict = (NSDictionary *)obj;
        weakSelf.page_total = [[[tempDict objectForKey:@"data"] objectForKey:@"edition"] integerValue];
        weakSelf.pagenum = weakSelf.page_total;
        [weakSelf p_solveData:weakSelf.pagenum];
    } failureBlock:^(id obj) {
        
    }];
}

#pragma mark - 数据解析
- (void)p_solveData:(NSInteger)pagenum
{
    //防止block循环引用
    __weak typeof(self) weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"collections/get_entries_by_collection_id/%ld", (long)pagenum];
    [ResolveData resolveDataWithUrlStr:url setHTTPMethod:@"GET" postBody:nil resolveBlock:^(id obj) {
        NSDictionary *tempDict = (NSDictionary *)obj;
        //        NSLog(@"%@",tempDict);
        
        if (pagenum == weakSelf.page_total) {
            //数据清空
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.listDict removeAllObjects];
        }
        
        if ([[tempDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in [tempDict objectForKey:@"data"]) {
                PictureStoryModel *pictureStoryModel = [[PictureStoryModel alloc] init];
                [pictureStoryModel setValuesForKeysWithDictionary:dict];
                if ([[DataBase sharedDataBase] pictureWithId:[NSString stringWithFormat:@"%@",pictureStoryModel.mID]]) {
                    pictureStoryModel.isCollect = YES;
                }
                if ([[DataBase sharedDataBase] authorWithId:[NSString stringWithFormat:@"%@",pictureStoryModel.user_id]]) {
                    pictureStoryModel.isAttention = YES;
                }
                if (nil == self.listDict[[NSString stringWithFormat:@"%ld",pagenum]]) {
                    [self.dataArray addObject:[NSString stringWithFormat:@"%ld",pagenum]];
                    NSMutableArray *tempArray = [NSMutableArray arrayWithObject:pictureStoryModel];
                    [self.listDict setObject:tempArray forKey:[NSString stringWithFormat:@"%ld",pagenum]];
                } else {
                    [self.listDict[[NSString stringWithFormat:@"%ld",pagenum]] addObject:pictureStoryModel];
                }
            }
        }
        [weakSelf.tableView reloadData];
        weakSelf.pagenum -= 1;
    } failureBlock:^(id obj) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listDict[self.dataArray[section]] count];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageItemCell *cell = [[ImageItemCell alloc] init];
    NSString *key = self.dataArray[indexPath.section];
    NSArray *array = self.listDict[key];
    PictureStoryModel *pictureStoryModel = array[indexPath.row];
    cell.pictureStoryModel = pictureStoryModel;
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageItemCell" forIndexPath:indexPath];
    [cell setTapClick:^(id sender) {
        [self showAuthor:indexPath];
    }];
    if (self.dataArray.count) {
        NSString *key = self.dataArray[indexPath.section];
        NSArray *array = self.listDict[key];
        PictureStoryModel *pictureStoryModel = array[indexPath.row];
        cell.pictureStoryModel = pictureStoryModel;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 39;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 35)];
    view.backgroundColor = UIColorFromRGB(0xEBEBF1);
    
    UIImageView *calendarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar"]];
    calendarImageView.frame = CGRectMake(20, 5, 24, 28);
    [view addSubview:calendarImageView];
    
    UILabel *calendarLabel = [[UILabel alloc] init];
    calendarLabel.textAlignment = NSTextAlignmentCenter;
    calendarLabel.font = [UIFont systemFontOfSize:11.0f];
    calendarLabel.textColor = UIColorFromRGB(0x999999);
    calendarLabel.text = [NSString stringWithFormat:@"%ld",(self.page_total - section)];
    calendarLabel.frame = CGRectMake(0, 0, 24, 28);
    [calendarImageView addSubview:calendarLabel];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.font = [UIFont systemFontOfSize:14.0f];
    numLabel.textColor = UIColorFromRGB(0x999999);
    numLabel.text = [NSString stringWithFormat:@" － 第%ld期图集",(self.page_total - section)];
    [view addSubview:numLabel];
    numLabel.frame = CGRectMake(65, 5, 200, 30);
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
- (void)showAuthor:(NSIndexPath *)indexPath {
    NSString *key = self.dataArray[indexPath.section];
    NSArray *array = self.listDict[key];
    PictureStoryModel *pictureStoryModel = array[indexPath.row];
    AuthorVC *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthorVC"];
    AuthorModel *authorModel = [[AuthorModel alloc] init];
    authorModel.mID = pictureStoryModel.user_id;
    authorModel.picture_url = pictureStoryModel.avatar;
    authorModel.user_name = pictureStoryModel.user_name;
    VC.userMode = authorModel;
    [self.navigationController pushViewController:VC animated:YES];
}

/*
- (void)searchAction {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    
    
    [self.navigationController pushViewController:searchVC animated:YES];
}*/
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSLog(@"%@",sender);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *key = self.dataArray[indexPath.section];
    NSArray *array = self.listDict[key];
    PictureStoryModel *pictureStoryModel = array[indexPath.row];
    if ([segue.identifier isEqualToString:@"pushImage"]) {
        ImageStoryVC *VC =  segue.destinationViewController;
        VC.pictureStoryModel = pictureStoryModel;
    }/*else if ([segue.identifier isEqualToString:@"pushUser"]) {
        AuthorVC *VC =  segue.destinationViewController;
        AuthorModel *authorModel = [[AuthorModel alloc] init];
        authorModel.mID = pictureStoryModel.user_id;
        authorModel.picture_url = pictureStoryModel.avatar;
        authorModel.user_name = pictureStoryModel.user_name;
        VC.userMode = authorModel;
    }*/
   
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)listDict
{
    if (!_listDict) {
        self.listDict = [NSMutableDictionary dictionary];
    }
    return _listDict;
}
@end
#import "DataBase.h"
#import "StoryModel.h"
@implementation ImageItemCell
- (void)setPictureStoryModel:(PictureStoryModel *)pictureStoryModel {
    _pictureStoryModel = pictureStoryModel;
    NSString *colorStr = [NSString stringWithFormat:@"0x%@",self.pictureStoryModel.img_color];
    unsigned long color = strtoul([colorStr UTF8String],0,0);
    self.picImageView.backgroundColor = UIColorFromRGB(color);
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.pictureStoryModel.thumb] placeholderImage:[[UIImage alloc] init]];

    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.pictureStoryModel.avatar] placeholderImage:[[UIImage alloc] init]];
    [self.avatarName setText:self.pictureStoryModel.user_name];
    [self.publishDate setText:self.pictureStoryModel.created];
    [self.location setText:self.pictureStoryModel.story_detail.location];
    
    if (self.pictureStoryModel.story_detail.story) {
        NSString *str = [NSString stringWithFormat:@"图片故事：%@ - %@",self.pictureStoryModel.story_detail.story,self.pictureStoryModel.story_detail.author];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:4];
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
        self.titleLabel.attributedText = text;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.avatarImageView addGestureRecognizer:tap];
    if (pictureStoryModel.isAttention) {
        [self.collect setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [self.collect setTitle:@"+ 关注" forState:UIControlStateNormal];

    }
}

- (IBAction)attentionAction:(UIButton *)sender {
    if ([[DataBase sharedDataBase] authorWithId:[NSString stringWithFormat:@"%@",_pictureStoryModel.user_id]]) {
        AuthorModel *authorModel = [[AuthorModel alloc] init];
        authorModel.mID = self.pictureStoryModel.user_id;
        authorModel.picture_url = self.pictureStoryModel.avatar;
        authorModel.user_name = self.pictureStoryModel.user_name;
        [[DataBase sharedDataBase] deleteAuthor:authorModel];
        _pictureStoryModel.isAttention = NO;
        [SVProgressHUD showSuccessWithStatus:@"取消关注"];
    }else{
        AuthorModel *authorModel = [[AuthorModel alloc] init];
        authorModel.mID = self.pictureStoryModel.user_id;
        authorModel.picture_url = self.pictureStoryModel.avatar;
        authorModel.user_name = self.pictureStoryModel.user_name;
        [[DataBase sharedDataBase] addAuthor:authorModel];
        _pictureStoryModel.isAttention = YES;
        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
    }
    self.pictureStoryModel = self.pictureStoryModel;
}

- (void)tapAction:(id)sender {
    self.TapClick(sender);
    NSLog(@"点击头像");
}

@end
