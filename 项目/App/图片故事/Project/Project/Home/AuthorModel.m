//
//  AuthorModel.m
//  majia
//
//  Created by pg on 2018/5/11.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "AuthorModel.h"

@implementation AuthorModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"profile_picture_url"]) {
        self.picture_url = [NSString stringWithFormat:@"%@",value];
        
        NSString *tempStr = value;
        NSArray *temArray = [tempStr componentsSeparatedByString:@"/palette/"];
        NSString *tempStr2 = [temArray lastObject];
        NSArray *temArray2 = [tempStr2 componentsSeparatedByString:@"/"];
        NSString *tempStr3 = [temArray2 firstObject];
        self.mID = tempStr3;
    }
}
@end
