//
//  InvitationModel.h
//  football
//
//  Created by masha on 2018/5/28.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVUser;
@interface InvitationModel : NSObject
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *locationName;
@property (nonatomic, strong)AVUser *user;
@property (nonatomic, strong)NSDate *date;
@end
