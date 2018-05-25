//
//  AlbumViewController.m
//  majia
//
//  Created by masha on 2018/5/14.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumDetailViewController.h"
#import "ResolveData.h"
#import "MJRefresh.h"

@interface AlbumViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger page_total;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addHeader];
    // Do any additional setup after loading the view.
}
#pragma mark -- 获得总页码
- (void)p_getNum {
    //防止block循环引用
    __weak typeof(self) weakSelf = self;
    
    NSString *url = @"collections/get_edition_num";
    
    [ResolveData resolveDataWithUrlStr:url setHTTPMethod:@"GET" postBody:nil resolveBlock:^(id obj) {
        NSDictionary *tempDict = (NSDictionary *)obj;
        weakSelf.page_total = [[[tempDict objectForKey:@"data"] objectForKey:@"edition"] integerValue];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.page_total;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumCell" forIndexPath:indexPath];
    cell.calendarLabel.text = [NSString stringWithFormat:@"%ld",self.page_total - indexPath.row];
    cell.numberLabel.text = [NSString stringWithFormat:@"- 第%ld期图集",self.page_total - indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"pushImag"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         AlbumDetailViewController *VC = segue.destinationViewController;
         VC.albumNum = (self.page_total - indexPath.row);
     }
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


@end

@implementation AlbumCell

@end

