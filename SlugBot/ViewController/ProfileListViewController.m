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
    
    UILabel* avatarCopyright;
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
    
    avatarCopyright = [UILabel new];
    avatarCopyright.text = LocalizedStr(@"CopyrightTwemoji");
    avatarCopyright.font = [UIFont systemFontOfSize:8];
    avatarCopyright.textColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:avatarCopyright];
    
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
    
    [avatarCopyright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view);
    }];
    
    profiles = [NSArray new];
    
    if([SBUser user].profileId > 0){
        [self.navigationController pushViewController:[ChatbotViewController new] animated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([SBUser user].clientId > 0) {
        NSLog(@"Registered User: #%ld\n", [SBUser user].clientId);
        [self reloadData];
        return;
    }
    SCRegisterClientRequest * request = [SCRegisterClientRequest new];
    request.platform = SCPlatform_Ios;
    [[MobileService service] registerClientWithRequest:request handler:^(SCRegisterClientResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Register Client: %@", error.localizedDescription);
            [self showNetworkAlert];
        }else{
            [SBUser user].clientId = response.clientId;
            [self reloadData];
        }
    }];
}

-(void)showNetworkAlert{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:LocalizedStr(@"NetworkAlertTitle")
                                                                   message:LocalizedStr(@"NetworkAlertMessage") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LocalizedStr(@"NetworkAlertActionOK") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)reloadData{
    if([SBUser user].clientId==0){
        [self showNetworkAlert];
        return;
    }
    SCListProfilesRequest * request = [SCListProfilesRequest new];
    [request setClientId:[SBUser user].clientId];
    [[MobileService service]
     listProfilesWithRequest:request
     handler:^(SCListProfilesResponse * _Nullable response, NSError * _Nullable error) {
         if(error){
             [self showNetworkAlert];
             return;
         }
         profiles = [response profilesArray];
         if(profiles.count == 0){
             [self createProfileWithName:LocalizedStr(@"DefaultProfileName")];
         }
         [collectionView reloadData];
     }];
}

-(void)createProfileWithName:(NSString*)name{
    AvatarListViewController * avatarListViewController = [AvatarListViewController new];
    avatarListViewController.name = name;
    [self.navigationController pushViewController:avatarListViewController animated:YES];
}

-(void)addProfile{
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
                                   [wSelf createProfileWithName:nameTextField.text];
                               }
                           }];
    UIAlertAction * cancelAction =
    [UIAlertAction actionWithTitle:LocalizedStr(@"AddProfileAlertActionCancel")
                             style:UIAlertActionStyleDefault
                           handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)hitAddProfileButton{
    if([SBUser user].clientId > 0) {
        [self addProfile];
        return;
    }
    SCRegisterClientRequest * request = [SCRegisterClientRequest new];
    request.platform = SCPlatform_Ios;
    [[MobileService service] registerClientWithRequest:request handler:^(SCRegisterClientResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Register Client: %@", error.localizedDescription);
            [self showNetworkAlert];
        }else{
            [SBUser user].clientId = response.clientId;
            [self addProfile];
        }
    }];
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
    [SBUser user].profileName = [profiles objectAtIndex:indexPath.row].name;
    
    [self.navigationController pushViewController:[ChatbotViewController new] animated:YES];
}

@end
