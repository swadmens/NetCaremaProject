//
//  PersonInfoViewController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/2/28.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "WWTableView.h"
#import "PersonInfoViewCell.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WWTableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation PersonInfoViewController
- (void)setupTableView
{
    self.tableView = [WWTableView new];
    self.tableView.backgroundColor = kColorBackgroundColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
    [self.view addSubview:self.tableView];
    [self.tableView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[PersonInfoViewCell class] forCellReuseIdentifier:[PersonInfoViewCell getCellIDStr]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    NSArray *arr = @[@{@"title":@"昵称",@"describe":_kUserModel.userInfo.user_name},
                     @{@"title":@"手机号码",@"describe":@"13162288787"},
                     @{@"title":@"邮箱",@"describe":_kUserModel.userInfo.email},
                     @{@"title":@"更改密码",@"describe":@"****"},];
    self.dataArray = arr;
    [self setupTableView];
    
    return;
    // 这里创建一个数组, 用来存储所有的相册
    NSMutableArray *allAlbumArray = [NSMutableArray array];
    // 获得相机胶卷
    // PHAssetCollectionTypeSmartAlbum = 2,  智能相册，系统自己分配和归纳的
    // PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,  相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 相机胶卷相簿存储到数组
    [allAlbumArray addObject:cameraRoll];
    // 获得所有的自定义相簿
    // PHAssetCollectionTypeAlbum = 1,  相册，系统外的
    // PHAssetCollectionSubtypeAlbumRegular = 2, 在iPhone中自己创建的相册
    // assetCollections是一个集合, 存储自定义的相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
         // 相簿存储到数组
         [allAlbumArray addObject:assetCollection];
    }
    // 这里假设你的本地相簿数目超过2个, 取出一个示例相簿为albumCollection
    PHAssetCollection *albumCollection = allAlbumArray[0];
//    NSLog(@"相簿名:%@ 照片个数:%ld", albumCollection.localizedTitle, albumCollection.count);
    // 获得相簿albumCollection中的所有PHAsset对象并存储在集合albumAssets中
    PHFetchResult<PHAsset *> *albumAssets = [PHAsset fetchAssetsInAssetCollection:albumCollection options:nil];
    
    // 取出一个视频对象, 这里假设albumAssets集合有视频文件
    
    for (PHAsset *asset in albumAssets) {
        // mediaType文件类型
        // PHAssetMediaTypeUnknown = 0, 位置类型
        // PHAssetMediaTypeImage   = 1, 图片
        // PHAssetMediaTypeVideo   = 2, 视频
        // PHAssetMediaTypeAudio   = 3, 音频
        int fileType = asset.mediaType;
        // 区分文件类型, 取视频文件
        if (fileType == PHAssetMediaTypeVideo)
        {
            // 取出视频文件
            // 取到一个视频对象就不再遍历, 因为这里我们只需要一个视频对象做示例
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            [[PHImageManager defaultManager]requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                // 获取信息 asset audioMix info
                // 上传视频时用到data
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                NSData *data = [NSData dataWithContentsOfURL:urlAsset.URL];
                DLog(@"asset  %@",asset);
                DLog(@"data  %@",data);
                DLog(@"info  %@",info);
            }];
        }
    }
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PersonInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonInfoViewCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineHidden = NO;
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell makeCellData:dic];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    [TargetEngine controller:nil pushToController:PushTargetMyFriendsView WithTargetId:nil];
    if (indexPath.row == 0) {
        //昵称
       
    }else if(indexPath.row == 1) {
        //手机号码
//        [TargetEngine controller:self pushToController:PushTargetAboutUsView WithTargetId:nil];
    }else if(indexPath.row == 2) {
        //邮箱
//        [TargetEngine controller:self pushToController:PushTargetAboutUsView WithTargetId:nil];
    }else{
        //更改密码
    }
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
