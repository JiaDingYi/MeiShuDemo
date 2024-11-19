//
//  MSPrerenderCell.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/8/4.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import "MSPrerenderCell.h"

@interface MSPrerenderCell ()

@end

@implementation MSPrerenderCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
