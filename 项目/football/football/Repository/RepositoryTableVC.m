//
//  RepositoryTableVC.m
//  football
//
//  Created by masha on 2018/5/16.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "RepositoryTableVC.h"
#import "AFNetworking.h"
#import "RepositoryModel.h"
#import "UIImageView+WebCache.h"
@interface RepositoryTableVC ()
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation RepositoryTableVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];//http://skyapp.mackentan.com/app/v6/article/list.do?t=1526451705000&did=gVFXdSxtHXf814c0770d&since=&ver=172&it=423997&fit=423997&sign=cf0a0300981bc97e90f67393239fe746a8f574a3&appid=com.jediapp.football&idfa=B329409F-B99C-4F9C-AD42-8F6E94703CC6
    NSDictionary *dic = @{@"pid":@0,
                          @"t":@"1526451705000",
                          @"did":@"gVFXdSxtHXf814c0770d",
                          @"since":@"",
                          @"ver":@172,
                          @"it":@"423997",
                          @"fit":@"423997",
                          @"sign":@"cf0a0300981bc97e90f67393239fe746a8f574a3",
                          @"appid":@"com.jediapp.football",
                          @"idfa":@"B329409F-B99C-4F9C-AD42-8F6E94703CC6"
                          };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://skyapp.mackentan.com/app/v6/article/list.do" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             id tempObj = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingAllowFragments) error:nil];
             NSDictionary *dict = tempObj;
             NSLog(@"====%@",dict);
             for (NSDictionary *tempDict in [[dict objectForKey:@"data"] objectForKey:@"articles"]) {
                 RepositoryModel *model = [[RepositoryModel alloc]init];
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
    RepositoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepositoryCell" forIndexPath:indexPath];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
@implementation RepositoryCell
-(void)setModel:(RepositoryModel *)model{
    _model = model;
    self.repositoryTitle.text = model.source;
    [self.repositoryImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[[UIImage alloc] init]];
}
@end
