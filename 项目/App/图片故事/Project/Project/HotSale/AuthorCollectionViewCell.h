//
//  AuthorCollectionViewCell.h
//  PictureStory
//
//  Created by edz on 16/10/19.
//  Copyright © 2016年 cocoa_niu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AuthorModel;

@interface AuthorCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *authorImv;
@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) AuthorModel *authorModel;

@end
