//
//  MSDemoSplashViewController.h
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/8/5.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MSDemoSplashDelegate <NSObject>

-(void) splashAdDidFinished;

@end


NS_ASSUME_NONNULL_BEGIN

@interface MSDemoSplashViewController : UIViewController

@property(nonatomic,weak) id<MSDemoSplashDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
