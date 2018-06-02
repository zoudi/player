//
//  CommunityTableVC.m
//  football
//
//  Created by masha on 2018/5/28.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "CommunityTableVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "InvitationModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+Time.h"
#import "TopicMessageVC.h"
#import "MJRefresh.h"

@interface CommunityTableVC ()
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation CommunityTableVC
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFooter];
    [self addHeader];
   
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-  (void)addMessageWith:(NSInteger)skip{
    AVQuery *query = [AVQuery queryWithClassName:@"Invitation"];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    query.limit = 10;
    if (skip) {
        query.skip = skip;
    }else{
        query.skip = 0;
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
        for (AVObject *obj in objects) {
            InvitationModel *model = [[InvitationModel alloc]init];
            model.topicId = obj.objectId;
            model.title = [obj objectForKey:@"title"];
            model.locationName = [obj objectForKey:@"locationName"];
            model.user = [obj objectForKey:@"user"];
            model.date = obj.createdAt;
            [self.dataArray addObject:model];
            
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - 刷新加载
- (void)addHeader
{
    __weak typeof(self) vc = self;
    // 添加下拉刷新头部控件
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.dataArray removeAllObjects];
        [self addMessageWith:0];
//        [vc.tableView reloadData];
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
        [self addMessageWith:self.dataArray.count];
//        [vc.tableView reloadData];
        // 结束刷新
        [vc.tableView.mj_footer endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityCell" forIndexPath:indexPath];
    if (self.dataArray.count) {
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
    }
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PushTopicMessage"]) {
        TopicMessageVC *vc = segue.destinationViewController;
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        vc.model = [self.dataArray objectAtIndex:index.row];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

@implementation CommunityCell
-(void)setModel:(InvitationModel *)model{
    _model = model;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[model.user objectForKey:@"imageUrl"]]];
    self.userName.text = [model.user objectForKey:@"username"];
    self.date.text = [NSString compareCurrentTime:model.date];
    self.title.text = model.title;
    self.location.text = model.locationName;
    if ([[model.user objectForKey:@"sex"] isEqualToString:@"男"]) {
        self.sex.image = [UIImage imageNamed:@"man"];
    }else{
        self.sex.image = [UIImage imageNamed:@"girl"];
    }
}

@end
