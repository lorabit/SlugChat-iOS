//
//  ProfileListViewController.m
//  SlugBot
//
//  Created by lorabit on 27/10/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "ProfileListViewController.h"
#import "MobileService.h"

@interface ProfileListViewController ()<
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@end

@implementation ProfileListViewController{
    UICollectionView * collectionView;
    UIButton * addProfileButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout* collectionViewLayout =
        [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setItemSize:CGSizeMake(60, 60)];
    collectionView = [[UICollectionView alloc]
                      initWithFrame:CGRectZero
                      collectionViewLayout:collectionViewLayout];
    [self.view addSubview:collectionView];
    
    addProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addProfileButton setBackgroundImage:[UIImage imageNamed:@"plus"]
                                forState:UIControlStateNormal];
    [addProfileButton addTarget:self
                         action:@selector(hitAddProfileButton)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addProfileButton];
    
    [addProfileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    
    SCRegisterClientRequest * request = [SCRegisterClientRequest new];
    [request setDeviceToken:@"test"];
    [request setPlatform:SCPlatform_Ios];
    [[MobileService service] registerClientWithRequest:request
                                               handler:^(SCRegisterClientResponse * _Nullable response, NSError * _Nullable error) {
                                                   NSLog(@"%@",response.debugDescription);
                                               }];
    
}

-(void)hitAddProfileButton{
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
