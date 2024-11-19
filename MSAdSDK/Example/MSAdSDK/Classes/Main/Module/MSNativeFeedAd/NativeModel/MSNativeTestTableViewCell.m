//
//  MSNativeTestTableViewCell.m
//  MSAdSDKDev
//
//  Created by leej on 2021/5/8.
//  Copyright © 2021 Adxdata. All rights reserved.
//

#import "MSNativeTestTableViewCell.h"

@interface MSNativeTestTableViewCell ()
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *content;
@property(nonatomic,strong)UIImageView *image;
@property(nonatomic,strong)UILabel *contentType;
@property(nonatomic,strong)UILabel *time;
@end

@implementation MSNativeTestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setModel:(MSNativeTestModel *)model{
    _model = model;
    [self layoutCellSubviews:model];
}
-(void)layoutCellSubviews:(MSNativeTestModel *)model{
    MSNativeTestModelType type = [model.modelType integerValue];
    self.contentType.text = model.contentType;
    self.title.hidden = YES;
    self.content.hidden = YES;
    self.image.hidden = YES;
    self.time.text = model.nowTime;
    if (type == MSNativeTestModelNoImageType) {
        self.title.hidden = NO;
        self.content.hidden = NO;
        self.title.text = model.title;
        self.content.text = model.desc;
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self).offset(10);
            make.right.mas_equalTo(self).offset(-20);
            make.height.mas_equalTo(15);
        }];
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.title.mas_bottom).offset(10);
            make.left.right.mas_equalTo(self.title);
        }];
        [self.contentType mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.title);
            make.bottom.mas_equalTo(self).offset(-5);
        }];
        [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-10);
            make.bottom.mas_equalTo(self.contentType);
        }];
    }else if (type == MSNativeTestModelUpWordDownImageType){
        self.title.hidden = NO;
        self.image.hidden = NO;
        self.title.text = model.title;
        self.image.image = [UIImage imageNamed:model.icon];
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self).offset(10);
            make.right.mas_equalTo(self).offset(-10);
        }];
        [self.image mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.title);
            make.right.mas_equalTo(self).offset(-10);
            make.top.mas_equalTo(self.title.mas_bottom).offset(10);
            make.height.mas_equalTo(200);
        }];
        [self.contentType mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.image);
            make.bottom.mas_equalTo(self).offset(-5);
        }];
        [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-10);
            make.bottom.mas_equalTo(self.contentType);
        }];
    }else if (type == MSNativeTestModelLeftImageRightWordType){
        self.title.hidden = NO;
        self.content.hidden = NO;
        self.image.hidden = NO;
        self.title.text = model.title;
        self.content.text = model.desc;
        self.image.image = [UIImage imageNamed:model.icon];
        [self.image mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(100, 80));
        }];
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.image.mas_right).offset(10);
            make.right.mas_equalTo(self).offset(-20);
            make.top.mas_equalTo(self.image);
        }];
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.title.mas_bottom).offset(10);
            make.left.mas_equalTo(self.title);
            make.right.mas_equalTo(self).offset(-20);
        }];
        [self.contentType mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.image);
            make.bottom.mas_equalTo(self).offset(-5);
        }];
        [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-10);
            make.bottom.mas_equalTo(self.contentType);
        }];
    }else if (type == MSNativeTestModelLeftWordRightImageType){
        self.title.hidden = NO;
        self.content.hidden = NO;
        self.image.hidden = NO;
        self.title.text = model.title;
        self.content.text = model.desc;
        self.image.image = [UIImage imageNamed:model.icon];
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self).offset(10);
            make.right.mas_equalTo(self).offset(-130);
        }];
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.title.mas_bottom).offset(10);
            make.left.right.mas_equalTo(self.title);
        }];
        [self.image mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-10);
            make.size.mas_equalTo(CGSizeMake(100, 80));
            make.top.mas_equalTo(self).offset(10);
        }];
        [self.contentType mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.title);
            make.bottom.mas_equalTo(self).offset(-5);
        }];
        [self.time mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-10);
            make.bottom.mas_equalTo(self.contentType);
        }];
    }
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.numberOfLines = 1;
        _title.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_title];
    }
    return _title;
}
-(UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.numberOfLines = 1;
        _time.textColor = MSUIColorFromRGB(0x666666);
        _time.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_time];
    }
    return _time;
}
-(UILabel *)contentType{
    if (!_contentType) {
        _contentType = [[UILabel alloc]init];
        _contentType.numberOfLines = 1;
        _contentType.font = [UIFont systemFontOfSize:11];
        _contentType.textColor = MSUIColorFromRGB(0x666666);
        [self.contentView addSubview:_contentType];
    }
    return _contentType;
}
-(UILabel *)content{
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.numberOfLines = 0;
        _content.font = [UIFont systemFontOfSize:11];
        _content.textColor = MSUIColorFromRGB(0x666666);
        [self.contentView addSubview:_content];
    }
    return _content;
}
-(UIImageView *)image{
    if (!_image) {
        _image = [[UIImageView alloc]init];
        [self.contentView addSubview:_image];
        _image.layer.cornerRadius = 5;
        _image.layer.masksToBounds = YES;
    }
    return _image;
}
@end
