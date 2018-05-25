//
//  NSString+Time.h
//  Demo
//
//  Created by YGLEE on 2018/3/6.
//  Copyright © 2018年 LiYugang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define scrnW [UIScreen mainScreen].bounds.size.width
#define scrnH [UIScreen mainScreen].bounds.size.height
@interface NSString (Time)
+ (NSString *)stringWithTime:(CGFloat)time;
@end
