//
//  MSDrawAdViewShowController.m
//  MSAdSDKDev
//
//  Created by leej on 2023/5/5.
//  Copyright © 2023 Adxdata. All rights reserved.
//

#import "MSDrawAdViewShowController.h"

@interface MSDrawAdViewShowController ()<UICollectionViewDelegate,UICollectionViewDataSource,MSDrawAdDelegate>
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSMutableArray *adData;
@end

@implementation MSDrawAdViewShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    //监听前后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
}
-(void)reloadAdDataSource:(NSArray<MSDrawAd *> *)dataSource{
    [self.adData addObjectsFromArray:dataSource];
    //获取到广告后指定delegate，以便接收广告回调
    for (int index=0; index<self.adData.count; index++) {
        MSDrawAd *draw = self.adData[index];
        draw.delegate = self;
    }
    [self.collectionView reloadData];
}
-(void)msWillEnterForeground{
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *index = [self.collectionView indexPathForCell:cell];
        MSDrawAd *draw = (MSDrawAd *)[self.adData objectAtIndex:index.item];
        [draw play];
    }
}
-(void)msDidEnterBackground{
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *index = [self.collectionView indexPathForCell:cell];
        MSDrawAd *draw = (MSDrawAd *)[self.adData objectAtIndex:index.item];
        [draw pause];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //此处仅demo测试，媒体按照自身需求决定什么时机释放
    if (!self.navigationController) {
        for (MSDrawAd *draw in self.adData) {
            [draw dismissDrawAdView];
            [draw stop];
        }
        [self.adData removeAllObjects];
    } else {
        [self msDidEnterBackground];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self msWillEnterForeground];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.adData.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    MSDrawAd *draw = self.adData[indexPath.item];
    [draw showAdViewInContainer:cell.contentView presentVC:self];
    [draw play];
    [draw setVideoMute:self.isMute];
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    MSDrawAd *draw = self.adData[indexPath.item];
    [draw pause];
    [draw dismissDrawAdView];
}
#pragma mark DrawAd-Delegate
-(void)msDrawAdVideoShowSuccess:(MSDrawAd *)drawAd{
    if (self.delegateBlock) {
        self.delegateBlock([NSString stringWithFormat:@"[%@广告]展示成功%@",drawAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]);
    }
}
-(void)msDrawAdVideoDidStartPlaying:(MSDrawAd *)drawAd{
    if (self.delegateBlock) {
        self.delegateBlock([NSString stringWithFormat:@"[%@广告]开始播放%@",drawAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]);
    }
}
-(void)msDrawAdVideoDidReplay:(MSDrawAd *)drawAd{
    if (self.delegateBlock) {
        self.delegateBlock([NSString stringWithFormat:@"[%@广告]重新播放%@",drawAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]);
    }
}
-(void)msDrawAdVideoDidPause:(MSDrawAd *)drawAd{
    NSLog(@"%@",[NSString stringWithFormat:@"msDrawAdVideoDidPause暂停播放%@=====位置%ld",drawAd,[self.adData indexOfObject:drawAd]]);
    if (self.delegateBlock) {
        self.delegateBlock([NSString stringWithFormat:@"[%@广告]暂停播放%@",drawAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]);
    }
}
-(void)msDrawAdVideoShowFailed:(MSDrawAd *)drawAd withError:(NSError *)error{
    if (self.delegateBlock) {
        self.delegateBlock([NSString stringWithFormat:@"[%@广告]展示失败%@",drawAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]);
    }
}
-(void)msDrawAdVideoDidComplete:(MSDrawAd *)drawAd{
    if (self.delegateBlock) {
        self.delegateBlock([NSString stringWithFormat:@"[%@广告]播放完成%@",drawAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]);
    }
}
-(void)msDrawAdVideoDidFailed:(MSDrawAd *)drawAd withError:(NSError *)error{
    if (self.delegateBlock) {
        self.delegateBlock([NSString stringWithFormat:@"[%@广告]播放失败%@",drawAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]);
    }
}
-(void)msDrawAdVideoDidClick:(MSDrawAd *)drawAd{
    if (self.delegateBlock) {
        self.delegateBlock([NSString stringWithFormat:@"[%@广告]被点击%@",drawAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]);
    }
    [drawAd pause];
}
-(void)msDrawAdVideoDetailClosed:(MSDrawAd *)drawAd{
    if (self.delegateBlock) {
        self.delegateBlock([NSString stringWithFormat:@"[%@广告]落地页被关闭%@",drawAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]);
    }
    [drawAd play];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-88);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height-88) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
-(NSMutableArray *)adData{
    if (!_adData) {
        _adData = [[NSMutableArray alloc]init];
    }
    return _adData;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}
@end
