//
//  SelectLocationTableVC.h
//  football
//
//  Created by masha on 2018/5/28.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>
#import "BaseViewController.h"

@class AMapPOI;
@interface SelectLocationTableVC : BaseTabLeViewController
@property (nonatomic, copy)void (^locationBlock) (AMapPOI *model);
@property (nonatomic, strong)CLLocation *location;

@end


@interface LocationCell : UITableViewCell
@property (nonatomic, strong)AMapPOI *model;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location;

@end
