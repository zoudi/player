//
//  CollectTableVC.m
//  Project
//
//  Created by masha on 2018/5/17.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "CollectTableVC.h"
#import "HomeTabVC.h"
#import "AuthorVC.h"
#import "AuthorModel.h"
#import "PictureStoryModel.h"
#import "DataBase.h"
#import "ImageStoryVC.h"

@interface CollectTableVC ()
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIView *defaultView;
@end

@implementation CollectTableVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[DataBase sharedDataBase] getAllPicture];
    for (PictureStoryModel *model in self.dataArray) {
        model.isCollect = YES;
        if ([[DataBase sharedDataBase] authorWithId:[NSString stringWithFormat:@"%@",model.user_id]]) {
            model.isAttention = YES;
        }
    }
    [self.tableView reloadData];
    if (!self.dataArray.count) {
        [self addDefaultView];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)addDefaultView
{
    [_defaultView removeFromSuperview];
    _defaultView = nil;
    _defaultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 51)];
    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 51)];
    defaultLabel.font = [UIFont systemFontOfSize:13.0f];
    defaultLabel.textAlignment = NSTextAlignmentCenter;
    defaultLabel.textColor = [UIColor grayColor];
    
    defaultLabel.text = @"您还没有收藏任何作品哦！";
    
    [_defaultView addSubview:defaultLabel];
    
    [self.tableView addSubview:_defaultView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageItemCell" forIndexPath:indexPath];
    [cell setTapClick:^(id sender) {
        [self showAuthor:indexPath];
    }];
    if (self.dataArray.count) {
        cell.pictureStoryModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    // Configure the cell...
    
    return cell;
}

- (void)showAuthor:(NSIndexPath *)indexPath {
    PictureStoryModel *pictureStoryModel = [self.dataArray objectAtIndex:indexPath.row];//array[indexPath.row];
    AuthorVC *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthorVC"];
    AuthorModel *authorModel = [[AuthorModel alloc] init];
    authorModel.mID = pictureStoryModel.user_id;
    authorModel.picture_url = pictureStoryModel.avatar;
    authorModel.user_name = pictureStoryModel.user_name;
    VC.userMode = authorModel;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushImage"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ImageStoryVC *VC =  segue.destinationViewController;
        VC.pictureStoryModel = [self.dataArray objectAtIndex:indexPath.row];
    }
}
@end
