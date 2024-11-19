//
//  MSViewController.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/17.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import "GDTViewController.h"

@interface GDTViewController ()

@end

@implementation GDTViewController

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
