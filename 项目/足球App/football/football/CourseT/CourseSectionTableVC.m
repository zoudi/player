//
//  CourseSectionTableVC.m
//  football
//
//  Created by masha on 2018/5/16.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "CourseSectionTableVC.h"
#import "AFNetworking.h"
#import "CourseModel.h"
#import "UIImageView+WebCache.h"
#import "ZDMoviePlayerController.h"
#import "YGPlayInfo.h"
#import "MJRefresh.h"
#import "YCDownloadManager.h"
//#import "VideoCacheController.h"

@interface CourseSectionTableVC ()<VideoListInfoCellDelegate>
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation CourseSectionTableVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) vc = self;
    // 添加下拉刷新头部控件
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.dataArray removeAllObjects];
        [self loadData];
        //        [vc.tableView reloadData];
        // 结束刷新
        [vc.tableView.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadData{
    
    NSMutableDictionary *dic = [@{@"pid":@(self.pid),
                                  //                          @"t":@"1526451309000",
                                  @"did":@"gVFXdSxtHXf814c0770d",
                                  @"ver":@172,
                                  @"it":@"423997",
                                  @"fit":@"423997",
                                  //                          @"sign":@"8a90af38a2458ee1d1d48dd5e4d0b5e7210971ef",
                                  @"appid":@"com.jediapp.football",
                                  @"idfa":@"B329409F-B99C-4F9C-AD42-8F6E94703CC6"
                                  } mutableCopy];
    if (self.pid == 149) {
        dic[@"t"]     = @"1526451309000";
        dic[@"sign"]  = @"8a90af38a2458ee1d1d48dd5e4d0b5e7210971ef";
    }
    if (self.pid == 154) {
        dic[@"t"]     = @"1526460381000";
        dic[@"sign"]  = @"50dcc75ff500d0a669401bf64842c1e610b81026";
    }
    if (self.pid == 153) {
        dic[@"t"]     = @"1526461195000";
        dic[@"sign"]  = @"3f4a734c3deee41d3e22aa234957098bb2cc5ab8";
    }
    if (self.pid == 152) {//http://skyapp.mackentan.com/app/v6/playlist.do?pid=152&t=1526461255000&did=gVFXdSxtHXf814c0770d&ver=172&it=423997&fit=423997&sign=41654276280c0fbf4891e397b807bdec47057a3b&appid=com.jediapp.football&idfa=B329409F-B99C-4F9C-AD42-8F6E94703CC6
        dic[@"t"]     = @"1526461255000";
        dic[@"sign"]  = @"41654276280c0fbf4891e397b807bdec47057a3b";
    }
    if (self.pid == 155) {//http://skyapp.mackentan.com/app/v6/playlist.do?pid=155&t=1526461302000&did=gVFXdSxtHXf814c0770d&ver=172&it=423997&fit=423997&sign=070d10274550b0b7c305fbbe576b4d7650218af6&appid=com.jediapp.football&idfa=B329409F-B99C-4F9C-AD42-8F6E94703CC6
        dic[@"t"]     = @"1526461302000";
        dic[@"sign"]  = @"070d10274550b0b7c305fbbe576b4d7650218af6";
    }
    if (self.pid == 561) {//http://skyapp.mackentan.com/app/v6/playlist.do?pid=561&t=1526461358000&did=gVFXdSxtHXf814c0770d&ver=172&it=423997&fit=423997&sign=cbc4f0a9b6b3db91da8b65722df701acfe3345ae&appid=com.jediapp.football&idfa=B329409F-B99C-4F9C-AD42-8F6E94703CC6
        dic[@"t"]     = @"1526461358000";
        dic[@"sign"]  = @"cbc4f0a9b6b3db91da8b65722df701acfe3345ae";
    }
    if (self.pid == 151) {//http://skyapp.mackentan.com/app/v6/playlist.do?pid=151&t=1526461396000&did=gVFXdSxtHXf814c0770d&ver=172&it=423997&fit=423997&sign=228fdeec30fd362dd4dca77df4180eca1bba5a1f&appid=com.jediapp.football&idfa=B329409F-B99C-4F9C-AD42-8F6E94703CC6
        dic[@"t"]     = @"1526461396000";
        dic[@"sign"]  = @"228fdeec30fd362dd4dca77df4180eca1bba5a1f";
    }
    if (self.pid == 150) {//http://skyapp.mackentan.com/app/v6/playlist.do?pid=150&t=1526461432000&did=gVFXdSxtHXf814c0770d&ver=172&it=423997&fit=423997&sign=f08bdba76c30b23d7fa6e0158b715c6152cc4d8a&appid=com.jediapp.football&idfa=B329409F-B99C-4F9C-AD42-8F6E94703CC6
        dic[@"t"]     = @"1526461432000";
        dic[@"sign"]  = @"f08bdba76c30b23d7fa6e0158b715c6152cc4d8a";
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://skyapp.mackentan.com/app/v6/playlist.do" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             id tempObj = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:nil];
             NSDictionary *dict = tempObj;
             for (NSDictionary *tempDict in [[dict objectForKey:@"data"] objectForKey:@"datalist"]) {
                 CourseModel *model = [[CourseModel alloc]init];
                 [model setValuesForKeysWithDictionary:tempDict];
                 [self.dataArray addObject:model];
                 [self.tableView reloadData];
                 
             }
             
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
             NSLog(@"%@",error);  //这里打印错误信息
         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseSectionCell" forIndexPath:indexPath];
    if (self.dataArray.count) {
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
    }
    cell.delegate = self;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ZDMoviePlayerController *video = [[ZDMoviePlayerController alloc] init];
//    [self.navigationController pushViewController:video animated:YES];
}

- (void)videoListCell:(CourseSectionCell *)cell downloadVideo:(CourseModel *)model {
//http://vodtest.lexue.com/video/71130874170909.mp4    资源问题不显示下载进度
   /* [YCDownloadManager startDownloadWithUrl:model.url fileName:model.title thumbImageUrl:model.cover];
    
    VideoCacheController *vc = [[VideoCacheController alloc] init];
    [self.navigationController pushViewController:vc animated:true];*/
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pushVideo"]) {
        ZDMoviePlayerController *vc = segue.destinationViewController;
        vc.index = [self.tableView indexPathForSelectedRow].row;
        NSMutableArray *data = [NSMutableArray array];
        if (self.dataArray.count) {
            for (CourseModel *model in self.dataArray) {
                YGPlayInfo *playInfo = [[YGPlayInfo alloc]init];
                playInfo.url = model.url;
                playInfo.title = model.title;
                playInfo.placeholder = model.cover;
                playInfo.artist = @"";
                [data addObject:playInfo];
            }
        }
        vc.videoClassifyId = [NSString stringWithFormat:@"%ld",self.pid];
        vc.dataArray = data;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

@implementation CourseSectionCell
-(void)setModel:(CourseModel *)model{
    _model = model;
    self.couresName.text = model.title;
    [self.couresImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[[UIImage alloc] init]];
    
}

- (IBAction)downloadBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(videoListCell:downloadVideo:)]) {
        [self.delegate videoListCell:self downloadVideo:self.model];
    }
}

- (void)setIsDownload:(BOOL)isDownload {
    
    _isDownload = isDownload;
    if (isDownload) {
        [self.downloadBtn setTitle:@"已下载" forState:UIControlStateNormal];
    }else{
        [self.downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    }
}
@end
