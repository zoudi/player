//
//  CourseModel.h
//  football
//
//  Created by masha on 2018/5/16.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseModel : NSObject
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *cover;
@property (nonatomic, strong)NSString *datatype;
@property (nonatomic, strong)NSString *duration;
@property (nonatomic, strong)NSString *listtype;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *sid;
@property (nonatomic, strong)NSString *tid;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, assign)NSInteger pid;
@property (nonatomic, assign)NSInteger priority;

@end
