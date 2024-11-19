//
//  MSQuickCreate.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/8/18.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import "MSQuickCreate.h"

@implementation MSQuickCreate

+(UIButton *)longActionBtn{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.cornerRadius  = 4;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth   = 1;
    btn.layer.borderColor   = [UIColor blueColor].CGColor;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    return btn;
}
+(UITextField *)defaultPidTextField{
    
    UITextField *tf  = [[UITextField alloc]init];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.textColor     = [UIColor darkGrayColor];
    tf.borderStyle   = UITextBorderStyleRoundedRect;
    
    return tf;
}

+(UILabel *)statusLabel{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor     = [UIColor lightGrayColor];
    label.font          = [UIFont systemFontOfSize:14];
    return label;
}

@end
