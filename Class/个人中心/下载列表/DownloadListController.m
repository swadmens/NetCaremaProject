//
//  DownloadListController.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/5.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DownloadListController.h"
#import "WWTableView.h"
#import "DownloadListCell.h"
#import "DownLoadSence.h"
#import "AFHTTPSessionManager.h"
#import "CarmeaVideosModel.h"
#import "YBDownloadManager.h"



@interface DownloadListController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic, strong) WWTableView *tableView;

@property (nonatomic,strong) NSMutableArray *lengthArray;

@property(nonatomic,strong)NSURLSessionDownloadTask*downloadTask;

///视频播放和下载用的url
@property (nonatomic,strong) NSURL *url;

@end

@implementation DownloadListController
-(NSMutableArray*)lengthArray
{
    if (!_lengthArray) {
        _lengthArray = [NSMutableArray array];
    }
    return _lengthArray;
}
-(void)setupTableView
{
    self.tableView = [WWTableView new];
    self.tableView.backgroundColor = kColorBackgroundColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88;
    [self.view addSubview:self.tableView];
    [self.tableView alignTop:@"10" leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[DownloadListCell class] forCellReuseIdentifier:[DownloadListCell getCellIDStr]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"下载列表";
    
    [YBDownloadManager defaultManager].maxDownloadingCount = 2;

    
    [self setupTableView];
    
//    [self downloadFileWithUrl:self.dataArray];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DownloadListCell *cell = [tableView dequeueReusableCellWithIdentifier:[DownloadListCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CarmeaVideosModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell makeCellData:model];
    cell.url = self.downLoad_id;

        
    return cell;
}
///通过url下载
- (void)downloadFileWithUrl:(NSArray *)urlArr
{
    [urlArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CarmeaVideosModel *model = obj;
        [self getVideoSize:model];
    }];
}
//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
       
    }
}

//获取视频大小
-(void)getVideoSize:(CarmeaVideosModel*)model
{
    __unsafe_unretained typeof(self) weak_self = self;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Content-Encoding"];
    [manager GET:model.hls parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {

    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dic = [(NSHTTPURLResponse *)task.response allHeaderFields];
        CGFloat textLength = [[dic objectForKey:@"Content-Length"] floatValue];
        DLog(@"length  =  %f",textLength);
        NSString *lengthStr = [NSString stringWithFormat:@"%.0f",textLength];
        
        NSString *urlString = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/record/download/%@/%@",self.downLoad_id,model.start_time];
        DownLoadSence *sence = [DownLoadSence new];
        sence.filePath = @"";
        sence.fileName = @"Video.mp4";
        sence.fileLenth = lengthStr;
        sence.needReDownload = YES;
        sence.url = urlString;
        [sence startDownload];
        sence.progressBlock = ^(float progress) {
            DLog(@"下载进度 ==  %f",progress)
        };
        sence.finishedBlock = ^(NSString *filePath) {
            DLog(@"文件路径  ==  %@",filePath);
            NSURL *url = [NSURL URLWithString:filePath];
            BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
            if (compatible)
            {
                //保存相册核心代码
                UISaveVideoAtPathToSavedPhotosAlbum([url path], weak_self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
            }
        };
    }];
    
    
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
