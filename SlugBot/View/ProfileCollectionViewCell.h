//
//  ProfileCollectionViewCell.h
//  SlugBot
//
//  Created by lorabit on 03/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SCMobile/Mobile.pbrpc.h>

@interface ProfileCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) SCProfile * profile;

@end
