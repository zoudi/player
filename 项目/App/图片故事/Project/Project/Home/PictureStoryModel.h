//
//  PictureStoryModel.h
//  majia
//
//  Created by pg on 2018/5/10.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoryModel;

@interface PictureStoryModel : NSObject
@property (nonatomic, copy) NSString *mID;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_email;
@property (nonatomic, copy) NSString *collection_id;
@property (nonatomic, copy) NSString *full_res;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) StoryModel *story_detail;
@property (nonatomic, copy) NSString *img_color;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, assign) BOOL isMemoryCached;//
@property (nonatomic, assign) BOOL isAttention;//关注用户
@property (nonatomic, assign) BOOL isCollect;//收藏这个动态

@end
