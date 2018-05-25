//
//  AuthorCollectionViewCell.m
//  PictureStory
//
//  Created by edz on 16/10/19.
//  Copyright © 2016年 cocoa_niu. All rights reserved.
//

#import "AuthorCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "AuthorModel.h"

@implementation AuthorCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self p_setupView];
        
    }
    return self;
}

- (void)p_setupView
{
    self.authorImv = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0, self.bounds.size.width, self.bounds.size.height)];
    self.authorImv.contentMode = UIViewContentModeScaleAspectFill;
    self.authorImv.layer.masksToBounds = YES;
    [self.contentView addSubview:self.authorImv];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    alphaView.alpha = 0.3;
    alphaView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:alphaView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height / 2 - 30, self.bounds.size.width,60)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:21.0f];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
}

- (void)setAuthorModel:(AuthorModel *)authorModel {
    _authorModel = authorModel;
    [self.authorImv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.authorModel.picture_url]]];
    self.nameLabel.text = self.authorModel.user_name;
}


@end
