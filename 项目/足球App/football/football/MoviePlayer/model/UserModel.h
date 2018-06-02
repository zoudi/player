//
//  UserModel.h
//  football
//
//  Created by masha on 2018/5/25.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic, strong)NSString *sex;
@property (nonatomic, strong)NSString *signature;
@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *birthday;
@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, strong)NSString *mobilePhoneNumber;

@end
