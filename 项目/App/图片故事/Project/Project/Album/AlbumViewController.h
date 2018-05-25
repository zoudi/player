//
//  AlbumViewController.h
//  majia
//
//  Created by masha on 2018/5/14.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController

@end
@interface AlbumCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *calendarLabel;

@end
