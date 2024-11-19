//
//  MSNativeFeedAdShowViewController.m
//  MSAdSDKDev
//
//  Created by leej on 2023/5/5.
//  Copyright © 2023 Adxdata. All rights reserved.
//

#import "MSNativeFeedAdShowViewController.h"
#import "MSNativeTestModel.h"
#import "MSNativeTestTableViewCell.h"
#import "MSNativeSimpleVideoAdView.h"
#import "MSNativeSimpleImageAdView.h"

@interface MSNativeFeedAdShowViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation MSNativeFeedAdShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _tableview = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableview];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (!self.navigationController) {
        [self removeNativeFeedAds];
        [self.tableview reloadData];
    }
}
-(void)closeCustomRenderView:(UIView *)adView{
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:self.dataArray];
    for (int index=0; index<self.dataArray.count; index++) {
        NSObject *ad = tempArr[index];
        if ([adView isKindOfClass:[MSNativeSimpleVideoAdView class]]) {
            MSNativeSimpleVideoAdView *video = (MSNativeSimpleVideoAdView *)adView;
            if ([video isEqual:ad]) {
                [video destoryNativeCustomVideoAdView];
                [tempArr removeObject:video];
                break;
            }
        } else if ([adView isKindOfClass:[MSNativeSimpleImageAdView class]]){
            MSNativeSimpleImageAdView *nativeAdView = (MSNativeSimpleImageAdView *)adView;
            if ([nativeAdView isEqual:ad]) {
                [nativeAdView destoryNativeCustomAdView];
                [tempArr removeObject:nativeAdView];
                break;
            }
        }
    }
    self.dataArray = tempArr;
    [self.tableview reloadData];
}
-(void)removeAdDataSource:(MSNativeFeedAdModel *)feedAd{
    //如果素材预处理失败，从当前列表中移除
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:self.dataArray];
    for (int index=0; index<self.dataArray.count; index++) {
        NSObject *ad = tempArr[index];
        if ([ad isKindOfClass:[MSNativeFeedAdModel class]]) {
            if ([tempArr containsObject:feedAd]) {
                [feedAd.feedView removeFromSuperview];
                [tempArr removeObject:feedAd];
                break;
            }
        } else if ([ad isKindOfClass:[UIView class]]){
            if ([ad isKindOfClass:[MSNativeSimpleVideoAdView class]]) {
                MSNativeSimpleVideoAdView *video = (MSNativeSimpleVideoAdView *)ad;
                if ([video.feedAdData isEqual:feedAd]) {
                    [video destoryNativeCustomVideoAdView];
                    [tempArr removeObject:video];
                    break;
                }
            } else if ([ad isKindOfClass:[MSNativeSimpleImageAdView class]]){
                MSNativeSimpleImageAdView *nativeAdView = (MSNativeSimpleImageAdView *)ad;
                if ([nativeAdView.feedAdData isEqual:feedAd]) {
                    [nativeAdView destoryNativeCustomAdView];
                    [tempArr removeObject:nativeAdView];
                    break;
                }
            }
        }
    }
    self.dataArray = tempArr;
    [self.tableview reloadData];
}
-(void)reloadAdDataSource:(NSArray *)dataSource{
    NSArray *nativeAdDataArray = dataSource;
    if (nativeAdDataArray.count > 0) {
        NSInteger count = nativeAdDataArray.count;
        NSInteger total = self.dataArray.count;
        for (int index=0; index<count; index++) {
            MSNativeFeedAdModel *obj = nativeAdDataArray[index];
            NSInteger position = random()%total;
            [self.dataArray insertObject:obj atIndex:position];
        }
    }
    [self.tableview reloadData];
}
- (void)removeNativeFeedAds{
    for (int index=0; index<self.dataArray.count; index++) {
        NSObject * obj = self.dataArray[index];
        if ([obj isKindOfClass:[MSNativeSimpleVideoAdView class]]) {
            MSNativeSimpleVideoAdView *video = (MSNativeSimpleVideoAdView *)obj;
            [video destoryNativeCustomVideoAdView];
            [video removeFromSuperview];
        } else if ([obj isKindOfClass:[MSNativeFeedAdModel class]]){
            MSNativeFeedAdModel *model = (MSNativeFeedAdModel *)obj;
            if (model.isNativeExpress) {
                [model.feedView removeFromSuperview];
            }
        }  else if ([obj isKindOfClass:[MSNativeSimpleImageAdView class]]){
            MSNativeSimpleImageAdView *adView = (MSNativeSimpleImageAdView *)obj;
            [adView destoryNativeCustomAdView];
            [adView removeFromSuperview];
        }
    }
    [self.dataArray removeAllObjects];
    self.dataArray = nil;
}
#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *view = [self.dataArray objectAtIndex:indexPath.row];
    if ([view isKindOfClass:[MSNativeTestModel class]]) {
        MSNativeTestModel *model = self.dataArray[indexPath.row];
        return [model cellHeight];
    //如果是自渲染图文广告
    }else if ([view isKindOfClass:[MSNativeSimpleImageAdView class]]){
        UIView *adView = (MSNativeCustomAdView *)view;
        return adView.bounds.size.height;
    }else if([view isKindOfClass:[MSNativeFeedAdModel class]]){
        MSNativeFeedAdModel *feedModel = (MSNativeFeedAdModel *)view;
        return feedModel.feedView.bounds.size.height;
    }else if([view isKindOfClass:[MSNativeSimpleVideoAdView class]]){
        MSNativeSimpleVideoAdView *videoAd = (MSNativeSimpleVideoAdView *)view;
        return videoAd.bounds.size.height;
    }
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *obj = nil;
    if (indexPath.row < self.dataArray.count) {
        obj = self.dataArray[indexPath.row];
    }
    if ([obj isKindOfClass:[MSNativeTestModel class]]) {
        MSNativeTestTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"MSNativeTestCellIdentifier"];
        if (!cell) {
            cell = [[MSNativeTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MSNativeTestCellIdentifier"];
        }
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nativeView"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nativeView"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *data = self.dataArray[indexPath.row];
    if ([data isKindOfClass:[MSNativeSimpleImageAdView class]]) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        MSNativeSimpleImageAdView *native = (MSNativeSimpleImageAdView *)data;
        [cell.contentView addSubview:native];
        [native showNativeAdWithClickViews:[native customImageAdViewClickViews] presentVC:self];
        native.presentVc = self;
        [native switchInteractionIcon];
    }else if ([data isKindOfClass:[MSNativeSimpleVideoAdView class]]){
        MSNativeSimpleVideoAdView *video = (MSNativeSimpleVideoAdView *)data;
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //绑定事件前传入
        [video muteVideo:self.isMute];
        [cell.contentView addSubview:video];
        [video showNativeAdWithClickViews:[video customVideoAdViewClickViews] presentVC:self];
        video.presentVc = self;
        [video switchInteractionIcon];
    }else if ([data isKindOfClass:[MSNativeTestModel class]]){
        
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        MSNativeFeedAdModel *viewData = (MSNativeFeedAdModel *)data;
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [viewData.feedView removeFromSuperview];
        viewData.presentVC = self;
        [cell.contentView addSubview:viewData.feedView];
        if (!viewData.isAdValid) {
            UILabel *toast = [[UILabel alloc]initWithFrame:cell.contentView.bounds];
            toast.text = @"广告已过期，请重新拉取广告";
            toast.textColor = [UIColor blueColor];
            [cell.contentView addSubview:toast];
            toast.textAlignment = NSTextAlignmentCenter;
        }
    }
}
//-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row < self.dataArray.count) {
//        NSObject *data = self.dataArray[indexPath.row];
//        if ([data isKindOfClass:[MSNativeSimpleImageAdView class]]) {
//            MSNativeSimpleImageAdView *native = (MSNativeSimpleImageAdView *)data;
//        }else if ([data isKindOfClass:[MSNativeSimpleVideoAdView class]]){
//            MSNativeSimpleVideoAdView *video = (MSNativeSimpleVideoAdView *)data;
//        }
//    }
//}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MSNativeResource.plist" ofType:nil];
        NSArray *datas = [[NSArray alloc]initWithContentsOfFile:path];
        for (int index=0; index<datas.count; index++) {
            MSNativeTestModel *model = [[MSNativeTestModel alloc]initWithDict:datas[index]];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}
@end
