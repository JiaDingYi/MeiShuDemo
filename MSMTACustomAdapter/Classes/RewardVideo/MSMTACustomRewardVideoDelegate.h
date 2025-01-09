//
//  MSMTACustomRewardVideoDelegate.h
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import <Foundation/Foundation.h>
#import <MSAdSDK/MSCustomRewardEventProtocol.h>
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMTACustomRewardVideoDelegate : NSObject <MentaUnifiedRewardVideoDelegate>
@property (nonatomic,weak) id<MSCustomRewardEventProtocol> event;
@property (nonatomic, assign, readonly) double ecpm;

@end

NS_ASSUME_NONNULL_END
