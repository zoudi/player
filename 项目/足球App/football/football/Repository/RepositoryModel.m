//
//  RepositoryModel.m
//  football
//
//  Created by masha on 2018/5/16.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "RepositoryModel.h"

@implementation RepositoryModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"profile_picture_url"]) {
        self.mid = [NSString stringWithFormat:@"%@",value];
    }
}
@end
