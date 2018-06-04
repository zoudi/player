//
//  CourseCollectionVC.m
//  football
//
//  Created by masha on 2018/6/2.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "CourseCollectionVC.h"
#import "AFNetworking.h"
#import "CourseModel.h"
#import "UIImageView+WebCache.h"
#import "CourseSectionTableVC.h"
#import "MJRefresh.h"

@interface CourseCollectionVC ()
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation CourseCollectionVC

//static NSString * const reuseIdentifier = @"Cell";
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.dataArray removeAllObjects];
        [self loadData];
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [self.collectionView.mj_header beginRefreshing];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    
    // Do any additional setup after loading the view.
}
- (void)loadData{
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
                 [self.collectionView reloadData];
                 
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//#pragma mark <UICollectionViewDataSource>
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CoureseCollectionCellItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CoureseCollectionCellItem" forIndexPath:indexPath];
    if (self.dataArray.count) {
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
    }
    // Configure the cell
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-31)/2, ([UIScreen mainScreen].bounds.size.width-31)/2 * 1.2);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSIndexPath *firstIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    

    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];//
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

@implementation CoureseCollectionCellItem
-(void)setModel:(CourseModel *)model{
    _model = model;
    self.courseName.text = model.title;
    [self.courseImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[[UIImage alloc] init]];
}

@end
