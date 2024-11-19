//
//  AdMobViewController.m
//  MSAdSDK_Example
//
//  Created by leej on 2022/9/19.
//  Copyright © 2022 Liumao. All rights reserved.
//

#import "AdMobViewController.h"

@interface AdMobViewController ()

@end

@implementation AdMobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}
-(void)loadData{
    NSMutableArray *marray = [NSMutableArray array];
    [self loadData:marray];
}

@end
