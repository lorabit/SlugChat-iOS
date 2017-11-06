//
//  AvatarListViewController.m
//  SlugBot
//
//  Created by lorabit on 04/11/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "AvatarListViewController.h"
#import "AvatarCollectionViewCell.h"
#import "MobileService.h"

#define NUM_AVATAR 40

@interface AvatarListViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@end

@implementation AvatarListViewController{
    UICollectionView * collectionView;
}

NSString* avatarCellIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedStr(@"AvatarListTitle");
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout* collectionViewLayout =
    [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setItemSize:CGSizeMake(106, 106)];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    collectionView = [[UICollectionView alloc]
                      initWithFrame:CGRectZero
                      collectionViewLayout:collectionViewLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView setContentInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    [collectionView registerClass:[AvatarCollectionViewCell class] forCellWithReuseIdentifier:avatarCellIdentifier];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return NUM_AVATAR;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AvatarCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:avatarCellIdentifier
                                                                                forIndexPath:indexPath];
    if(!cell){
        cell = [AvatarCollectionViewCell new];
    }
    
    cell.avatarId = indexPath.row;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SCProfile * profile = [SCProfile new];
    profile.name = self.name;
    profile.clientId = [SBUser user].clientId;
    profile.avatar = (int)indexPath.row;
    [[MobileService service] createProfileWithRequest:profile
                                              handler:^(SCProfile * _Nullable response, NSError * _Nullable error) {
                                                  if(error){
                                                      
                                                  }else{
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  }
                                              }];
}



@end
