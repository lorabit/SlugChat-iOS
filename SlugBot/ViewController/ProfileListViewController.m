//
//  ProfileListViewController.m
//  SlugBot
//
//  Created by lorabit on 27/10/2017.
//  Copyright © 2017 UCSC. All rights reserved.
//

#import "ProfileListViewController.h"
#import "MobileService.h"
#import "ProfileCollectionViewCell.h"
#import "AvatarListViewController.h"
#import "ChatbotViewController.h"

@interface ProfileListViewController ()<
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@end

@implementation ProfileListViewController{
    UICollectionView * collectionView;
    UIButton * addProfileButton;
    NSArray<SCProfile*>* profiles;
}

NSString* profileCellIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedStr(@"ProfileListTitle");
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout* collectionViewLayout =
        [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setItemSize:CGSizeMake(106, 120)];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    collectionView = [[UICollectionView alloc]
                      initWithFrame:CGRectZero
                      collectionViewLayout:collectionViewLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[ProfileCollectionViewCell class] forCellWithReuseIdentifier:profileCellIdentifier];
    collectionView.delegate = self;
    collectionView.dataSource = self;
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
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(addProfileButton.mas_top).offset(-20);
    }];
    
    profiles = [NSArray new];
    
    if([SBUser user].profileId > 0){
        [self.navigationController pushViewController:[ChatbotViewController new] animated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

-(void)reloadData{
    SCListProfilesRequest * request = [SCListProfilesRequest new];
    [request setClientId:[SBUser user].clientId];
    [[MobileService service]
     listProfilesWithRequest:request
     handler:^(SCListProfilesResponse * _Nullable response, NSError * _Nullable error) {
         profiles = [response profilesArray];
         [collectionView reloadData];
     }];
}

-(void)hitAddProfileButton{
 UIAlertController* alert =
    [UIAlertController alertControllerWithTitle:LocalizedStr(@"AddProfileAlertTitle")
                                        message:LocalizedStr(@"AddProfileAlertMessage")
                                 preferredStyle:UIAlertControllerStyleAlert];
    WS(wSelf);
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = LocalizedStr(@"AddProfileAlertPlaceholder");
    }];
    UIAlertAction * okAction =
    [UIAlertAction actionWithTitle:LocalizedStr(@"AddProfileAlertActionOK")
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * _Nonnull action) {
                               UITextField * nameTextField = [alert textFields][0];
                               if(nameTextField.text.length>0){
                                   AvatarListViewController * avatarListViewController = [AvatarListViewController new];
                                   avatarListViewController.name = nameTextField.text;
                                   [wSelf.navigationController pushViewController:avatarListViewController animated:YES];
                               }
                           }];
    UIAlertAction * cancelAction =
    [UIAlertAction actionWithTitle:LocalizedStr(@"AddProfileAlertActionCancel")
                             style:UIAlertActionStyleDefault
                           handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
//    SCProfile* profile = [SCProfile new];
//    [profile setClientId:9];
//    [profile setName:@"test profile"];
//    [profile setAvatar:1];
//    [[MobileService service] createProfileWithRequest:profile
//                                              handler:^(SCProfile * _Nullable response, NSError * _Nullable error) {
//                                                  NSLog(@"Profile created: %d\n", response.profileId);
//                                                  [self reloadData];
//                                              }];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [profiles count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:profileCellIdentifier
                                                                                forIndexPath:indexPath];
    if(!cell){
        cell = [ProfileCollectionViewCell new];
    }
    
    cell.profile = [profiles objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [SBUser user].profileId = [profiles objectAtIndex:indexPath.row].profileId;
    [self.navigationController pushViewController:[ChatbotViewController new] animated:YES];
}

@end
