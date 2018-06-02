//
//  CourseTableVC.m
//  football
//
//  Created by masha on 2018/5/16.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "CourseTableVC.h"
#import "AFNetworking.h"
#import "CourseModel.h"
#import "UIImageView+WebCache.h"
#import "CourseSectionTableVC.h"

@interface CourseTableVC ()
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation CourseTableVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];//http://skyapp.mackentan.com/app/v6/playlist.do?pid=0&t=1526451194000&did=gVFXdSxtHXf814c0770d&ver=172&it=423997&fit=423997&sign=73dceee3902d404aa20a1f3556148c26c73176da&appid=com.jediapp.football&idfa=B329409F-B99C-4F9C-AD42-8F6E94703CC6
    NSDictionary *dic = @{@"pid":@0,
                          @"t":@"1526451194000",
                          @"did":@"gVFXdSxtHXf814c0770d",
                          @"ver":@172,
                          @"it":@"423997",
                          @"fit":@"423997",
                          @"sign":@"73dceee3902d404aa20a1f3556148c26c73176da",
                          @"appid":@"com.jediapp.football",
                          @"idfa":@"B329409F-B99C-4F9C-AD42-8F6E94703CC6"
                         };

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
    
 


    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCellItem *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCellItem" forIndexPath:indexPath];
    if (self.dataArray.count) {
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"CourseSection"]) {
        CourseSectionTableVC *VC = segue.destinationViewController;
        CourseModel *model = [self.dataArray objectAtIndex:indexPath.row];
        VC.pid = model.pid;
        VC.title = model.title;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

@implementation CourseCellItem
-(void)setModel:(CourseModel *)model{
    _model = model;
    self.courseName.text = model.title;
    [self.courseImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[[UIImage alloc] init]];
}

@end
