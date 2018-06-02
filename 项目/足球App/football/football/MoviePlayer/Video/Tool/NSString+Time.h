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
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface NSString (Time)
+ (NSString *)stringWithTime:(CGFloat)time;
+ (NSString *) compareCurrentTime:(NSDate *)date;
@end
