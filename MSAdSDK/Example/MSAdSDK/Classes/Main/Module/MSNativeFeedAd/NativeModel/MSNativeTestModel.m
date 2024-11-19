//
//  MSNativeTestModel.m
//  MSAdSDKDev
//
//  Created by leej on 2021/5/8.
//  Copyright © 2021 Adxdata. All rights reserved.
//

#import "MSNativeTestModel.h"
#import "MSTools.h"

@implementation MSNativeTestModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
-(void)setNilValueForKey:(NSString *)key{}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
-(CGFloat)cellHeight{
    MSNativeTestModelType type = [self.modelType integerValue];
    CGFloat height = 40;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (type == MSNativeTestModelNoImageType) {
        CGFloat titileH = [MSTools getTextSize:self.title fontSize:13 maxChatWidth:width - 20].height;
        CGFloat descH = [MSTools getTextSize:self.desc fontSize:13 maxChatWidth:width - 20].height;
        height += titileH+descH;
    }else if (type == MSNativeTestModelUpWordDownImageType){
        CGFloat titileH = [MSTools getTextSize:self.title fontSize:13 maxChatWidth:width - 20].height;
        height += titileH+210;
    }else if (type == MSNativeTestModelLeftImageRightWordType){
        CGFloat titileH = [MSTools getTextSize:self.title fontSize:13 maxChatWidth:width - 150].height;
        CGFloat descH = [MSTools getTextSize:self.desc fontSize:11 maxChatWidth:width - 150].height;
        if (titileH+descH > 100) {
            height += titileH+descH;
        }else{
            height += 80;
        }
    }else if (type == MSNativeTestModelLeftWordRightImageType){
        CGFloat titileH = [MSTools getTextSize:self.title fontSize:13 maxChatWidth:width - 150].height;
        CGFloat descH = [MSTools getTextSize:self.desc fontSize:11 maxChatWidth:width - 150].height;
        if (titileH+descH > 100) {
            height += titileH+descH;
        }else{
            height += 80;
        }
    }
    return height;
}
@end
