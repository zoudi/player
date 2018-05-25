//
//  MainTouchTableTableView.m
//  majia
//
//  Created by masha on 2018/5/14.
//  Copyright © 2018年 zoudi. All rights reserved.
//

#import "MainTouchTableTableView.h"

@implementation MainTouchTableTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
