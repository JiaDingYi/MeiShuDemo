//
//  MSTools.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/9/2.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import "MSTools.h"
#import <objc/runtime.h>

@implementation MSTools

+ (CGSize)getTextSize:(NSString *)message fontSize:(NSInteger)fontSize maxChatWidth:(NSInteger)maxChatWidth{

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes     = @{
                                    NSFontAttributeName:[UIFont systemFontOfSize:fontSize]
                                    };
    return  [message boundingRectWithSize:CGSizeMake(maxChatWidth, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attributes
                                        context:nil].size;
}
//时间戳变为格式时间
+ (NSString *)convertStrToTime:(NSString *)timeStr{
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[timeStr longLongValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:date];
    return timeString;
}
+ (NSMutableArray *)adSupportProtocol:(NSString *)protocolName{
    NSMutableArray *arrM = [[NSMutableArray alloc]init];
    if (protocolName.length <= 0) {
        return arrM;
    }
    unsigned int count = 0;
    struct objc_method_description  * desc = protocol_copyMethodDescriptionList(NSProtocolFromString(protocolName),NO,YES,&count);
    for (int i = 0; i < count; i++) {
        struct objc_method_description temp = desc[i];
        [arrM addObject:NSStringFromSelector(temp.name)];
    }
    free(desc);
    return arrM;
}
@end
