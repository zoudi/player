//
//  PictureStoryModel.m
//  majia
//
//  Created by pg on 2018/5/10.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "PictureStoryModel.h"
#import "StoryModel.h"

@implementation PictureStoryModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.mID = [NSString stringWithFormat:@"%@",value];
    }  else if ([key isEqualToString:@"story"]) {
        NSData *jsonData = [value dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        
        self.story_detail = [[StoryModel alloc] init];
        [self.story_detail setValuesForKeysWithDictionary:dic];
        
    }
}

@end
