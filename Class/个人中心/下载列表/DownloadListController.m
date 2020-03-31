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

@interface DownloadListController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate>
{
    BOOL _isHadFirst; // 是否第一次加载了
}
@property (nonatomic, strong) WWTableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong)NSURLSessionDownloadTask*downloadTask;

///视频播放和下载用的url
@property (nonatomic,strong) NSURL *url;

@end

@implementation DownloadListController
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    [self setupTableView];
    
    
    NSDictionary *dic = [WWPublicMethod objectTransFromJson:self.downLoad_id];
    NSString *ids = [dic objectForKey:@"id"];
    NSString *period = [dic objectForKey:@"period"];

    NSString *urlString = [NSString stringWithFormat:@"http://192.168.6.120:10102/outer/liveqing/record/download/%@/%@",ids,period];
    
    [self downloadFileWithUrl:urlString];

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataArray.count;
    return 4;
}
#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DownloadListCell *cell = [tableView dequeueReusableCellWithIdentifier:[DownloadListCell getCellIDStr] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
///下载
- (void)download:(UIBarButtonItem *)btnItem{
 ///初始化Session
// _session = [XMConciseVedioPlayer getSession:_session];
  
 ///self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
  
// [self downloadFileWithUrl:self.url];
  
}
///通过url下载
- (void)downloadFileWithUrl:(NSString *)url
{
    DownLoadSence *sence = [DownLoadSence new];
    sence.url = url;
    sence.filePath = @"";
    sence.fileName = @"Video.mp4";
    sence.needReDownload = YES;
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
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    };

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
