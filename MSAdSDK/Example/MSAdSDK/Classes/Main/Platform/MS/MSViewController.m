//
//  MSViewController.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/17.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import "MSViewController.h"

@interface MSViewController ()

@end

@implementation MSViewController

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
