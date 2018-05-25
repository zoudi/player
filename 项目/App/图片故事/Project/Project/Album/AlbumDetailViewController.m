//
//  AlbumDetailViewController.m
//  majia
//
//  Created by masha on 2018/5/14.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "AlbumDetailViewController.h"
#import "PictureStoryModel.h"
#import "ResolveData.h"
#import "MJRefresh.h"
#import "HomeTabVC.h"
#import "ImageStoryVC.h"
#import "AuthorVC.h"
#import "AuthorModel.h"
#import "DataBase.h"

@interface AlbumDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AlbumDetailViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"第%ld期图集",self.albumNum];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self addHeader];
}



#pragma mark -- 获得总页码
- (void)p_getNum {
    //防止block循环引用
    __weak typeof(self) weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:@"collections/get_entries_by_collection_id/%ld", (long)self.albumNum];
    [ResolveData resolveDataWithUrlStr:url setHTTPMethod:@"GET" postBody:nil resolveBlock:^(id obj) {
        NSDictionary *tempDict = (NSDictionary *)obj;
        NSLog(@"%@",tempDict);
        [weakSelf.dataArray removeAllObjects];
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
                [weakSelf.dataArray addObject:pictureStoryModel];
            }
        }
        [weakSelf.tableView reloadData];
    } failureBlock:^(id obj) {
        
    }];
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    HomeTableViewCell *cell = [[HomeTableViewCell alloc] init];
//    cell.pictureStoryModel = [self.dataArray objectAtIndex:indexPath.row];
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageItemCell" forIndexPath:indexPath];
    [cell setTapClick:^(id sender) {
        //        [self showAuthor:indexPath];
    }];
    if (self.dataArray.count) {
        PictureStoryModel *pictureStoryModel = self.dataArray[indexPath.row];
        cell.pictureStoryModel = pictureStoryModel;
    }
    [cell setTapClick:^(id sender) {
        [self showAuthor:indexPath];
    }];
    return cell;
}

- (void)showAuthor:(NSIndexPath *)indexPath {
    PictureStoryModel *pictureStoryModel = self.dataArray[indexPath.row];
    AuthorVC *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthorVC"];
    AuthorModel *authorModel = [[AuthorModel alloc] init];
    authorModel.mID = pictureStoryModel.user_id;
    authorModel.picture_url = pictureStoryModel.avatar;
    authorModel.user_name = pictureStoryModel.user_name;
    VC.userMode = authorModel;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    PictureStoryModel *pictureStoryModel = self.dataArray[indexPath.row];
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

@end
