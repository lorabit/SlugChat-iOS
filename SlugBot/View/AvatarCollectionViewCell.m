//
//  AvatarCollectionViewCell.m
//  SlugBot
//
//  Created by lorabit on 04/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "AvatarCollectionViewCell.h"

@implementation AvatarCollectionViewCell{
    UIImageView *avatarView;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.contentView.backgroundColor = BACKGROUNDCOLOR_AVATAR;
        avatarView = [UIImageView new];
        [self.contentView addSubview:avatarView];
        [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
    return self;
}

-(void)setAvatarId:(NSInteger)avatarId{
    UIImage* avatar = [UIImage imageNamed:[NSString stringWithFormat:@"avatar_%ld",avatarId]];
    avatarView.image = avatar;
}

@end
