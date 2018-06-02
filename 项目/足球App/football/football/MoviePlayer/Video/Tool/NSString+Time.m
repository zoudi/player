//
//  NSString+Time.m
//  Demo
//
//  Created by YGLEE on 2018/3/6.
//  Copyright © 2018年 LiYugang. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)
+ (NSString *)stringWithTime:(CGFloat)time;
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    
    if (time >= 3600) {
        [dateFmt setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFmt setDateFormat:@"mm:ss"];
    }
    return [dateFmt stringFromDate:date];
}

+ (NSString *) compareCurrentTime:(NSDate *)date;
{
    //得到与当前时间差
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp];
    }
    
    return  result;
}

@end
