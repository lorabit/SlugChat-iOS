//
//  ProfileCollectionViewCell.m
//  SlugBot
//
//  Created by lorabit on 03/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "ProfileCollectionViewCell.h"

@implementation ProfileCollectionViewCell{
    UIImageView *avatarView;
    UILabel* nameLab;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.contentView.backgroundColor = BACKGROUNDCOLOR_AVATAR;
        avatarView = [UIImageView new];
        [self.contentView addSubview:avatarView];
        [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@90);
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(5);
        }];
        
        nameLab = [UILabel new];
        nameLab.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(avatarView.mas_bottom).offset(5);
        }];
        
       
    }
    return self;
}


-(void)setProfile:(SCProfile *)profile{
    UIImage* avatar = [UIImage imageNamed:[NSString stringWithFormat:@"avatar_%d",profile.avatar]];
    avatarView.image = avatar;
    nameLab.text = profile.name;
}

@end
