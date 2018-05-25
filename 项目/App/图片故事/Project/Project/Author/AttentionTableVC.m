//
//  AttentionTableVC.m
//  Project
//
//  Created by masha on 2018/5/17.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "AttentionTableVC.h"
#import "DataBase.h"
#import "AuthorModel.h"
#import "AuthorVC.h"
#import "UIImageView+WebCache.h"

@interface AttentionTableVC ()
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIView *defaultView;
@end

@implementation AttentionTableVC
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)reloData{
    self.dataArray = [[DataBase sharedDataBase] getAllAuthor];
    [self.tableView reloadData];
    if (!self.dataArray.count) {
        [self addDefaultView];
    }
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
    
    defaultLabel.text = @"您还没有关注任何人哦！";
    
    [_defaultView addSubview:defaultLabel];
    
    [self.tableView addSubview:_defaultView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentionCell" forIndexPath:indexPath];
    if (self.dataArray.count) {
        cell.model = [self.dataArray objectAtIndex:indexPath.row];
    }
    cell.deleteAutor = ^(id sender) {
        [self reloData];
    };
    // Configure the cell...
    
    return cell;
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
    if ([segue.identifier isEqualToString:@"pushUser"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        AuthorVC *VC =  segue.destinationViewController;
        VC.userMode = [self.dataArray objectAtIndex:indexPath.row];
    }
}

@end

@implementation AttentionCell
- (void)setModel:(AuthorModel *)model{
    _model = model;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.picture_url] placeholderImage:[[UIImage alloc] init]];
    self.userName.text = model.user_name;
    
}
- (IBAction)attentionAction:(UIButton *)sender {
    [[DataBase sharedDataBase] deleteAuthor:self.model];
    self.deleteAutor(sender);
}
@end
