//
//  SelectDateVC.h
//  Project
//
//  Created by masha on 2018/5/20.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SelectDateVC : BaseViewController
@property (nonatomic, copy)void (^dateBlock) (NSString *strValue);
@property (nonatomic, strong)NSString *dateStr;
@end
