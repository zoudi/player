//
//  AuthorTableViewController.h
//  majia
//
//  Created by masha on 2018/5/14.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AuthorModel;
@interface ParentClassScrollViewController : UIViewController
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL canScroll;

@end

@interface AuthorTableViewController : ParentClassScrollViewController
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) AuthorModel *authorModel;
@end
