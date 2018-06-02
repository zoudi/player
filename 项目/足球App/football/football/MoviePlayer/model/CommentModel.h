//
//  CommentModel.h
//  football
//
//  Created by masha on 2018/5/25.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@interface CommentModel : NSObject
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *videoClassifyId;
@property (nonatomic, strong)NSDate *createdAt;
@property (nonatomic, strong)UserModel *user;

@end
