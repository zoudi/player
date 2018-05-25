//
//  AuthorViewController.m
//  majia
//
//  Created by masha on 2018/5/14.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "AuthorViewController.h"
#import "BaseCollectionView.h"
#import "AuthorCollectionViewCell.h"
#import "ResolveData.h"
#import "AuthorModel.h"
#import "MJRefresh.h"
#import "AuthorVC.h"


#define UI_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define UI_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


@interface AuthorViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property(nonatomic,strong) BaseCollectionView *mainView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation AuthorViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = nil;
    
    //设置代理
    self.mainView.collectionView.dataSource = self;
    self.mainView.collectionView.delegate = self;
    
    [self.mainView.collectionView registerClass:[AuthorCollectionViewCell class] forCellWithReuseIdentifier:@"authorCell"];
    
    
    //数据解析
    [self addHeader];
    
    
}

- (void)loadView
{
    self.mainView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, 0,UI_SCREEN_WIDTH , UI_SCREEN_HEIGHT - 64 - 49 - 44)];
    self.view = self.mainView;
}

#pragma mark - 数据解析
- (void)p_solveData:(NSInteger)type
{
    /*
     最热：
     http://www.polaxiong.com/palette/get_top_iso_users
     最新用户：
     http://www.polaxiong.com/palette/get_new_iso_users
     贡献最大：
     http://www.polaxiong.com/palette/get_rising_iso_users
     */
    //防止block循环引用
    __weak typeof(self) weakSelf = self;
    
    NSString *url;
    if (type == 1) {
        url = @"palette/get_top_iso_users";
    } else if (type == 2) {
        url = @"palette/get_new_iso_users";
    } else {
        url = @"palette/get_rising_iso_users";
    }
    
    [ResolveData resolveDataWithUrlStr:url setHTTPMethod:@"GET" postBody:nil resolveBlock:^(id obj) {
        NSDictionary *tempDict = (NSDictionary *)obj;
        NSLog(@"%@",tempDict);
        [weakSelf.dataArray removeAllObjects];
        if ([[tempDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in [tempDict objectForKey:@"data"]) {
                AuthorModel *authorModel = [[AuthorModel alloc] init];
                [authorModel setValuesForKeysWithDictionary:dict];
                [weakSelf.dataArray addObject:authorModel];
            }
        }
        [weakSelf.mainView.collectionView reloadData];
    } failureBlock:^(id obj) {
        
    }];
}

#pragma mark - 刷新加载
- (void)addHeader
{
    __weak typeof(self) vc = self;
    // 添加下拉刷新头部控件
    
    self.mainView.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [vc p_solveData:vc.type];
        // 结束刷新
        [vc.mainView.collectionView.mj_footer resetNoMoreData];
        [vc.mainView.collectionView.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [self.mainView.collectionView.mj_header beginRefreshing];
}



//有多少个分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个分组有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//设置并返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //从重用池中获取cell,如果没有就创建
    AuthorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"authorCell" forIndexPath:indexPath];
    
    AuthorModel *authorModel = self.dataArray[indexPath.item];
    
    cell.authorModel = authorModel;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AuthorVC *authorDVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthorVC"];
    authorDVC.userMode = self.dataArray[indexPath.item];
    
    [self.navigationController pushViewController:authorDVC animated:YES];
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

@end
