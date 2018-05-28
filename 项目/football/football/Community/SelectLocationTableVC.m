//
//  SelectLocationTableVC.m
//  football
//
//  Created by masha on 2018/5/28.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "SelectLocationTableVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MBProgressHUD+ZD.h"

@interface SelectLocationTableVC ()<AMapSearchDelegate>
@property (nonatomic, strong)AMapSearchAPI *search;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation SelectLocationTableVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.location) {
        CLLocationCoordinate2D coordinate = self.location.coordinate;
//        NSLog(@"您的当前位置:经度：%f,纬度：%f",coordinate.longitude,coordinate.latitude);
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
        
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        
        request.location            = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        request.keywords            = @"";
        request.offset              = 50;//查询50条数据
        /* 按照距离排序. */
        request.sortrule            = 0;
        request.requireExtension    = YES;
        [self.search AMapPOIAroundSearch:request];
        
    }else{
        [MBProgressHUD showError:@"获取地理位置失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        [MBProgressHUD showError:@"查询失败"];
        return;
    }else{
        [self.dataArray addObjectsFromArray:response.pois];
        [self.tableView reloadData];
    }
    
    //解析response获取POI信息，具体解析见 Demo
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.locationBlock([self.dataArray objectAtIndex:indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation LocationCell
-(void)setModel:(AMapPOI *)model{
    _model = model;
    self.name.text = model.name;
    self.location.text = model.address;
}

@end
