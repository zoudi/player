//
//  StoryModel.h
//  majia
//
//  Created by pg on 2018/5/10.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryModel : NSObject
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *story;

/**
 *  所有者
 */
@property(nonatomic, copy ) NSString *own_id;
@end
