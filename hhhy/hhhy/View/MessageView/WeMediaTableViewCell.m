//
//  WeMediaTableViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/4.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "WeMediaTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation WeMediaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setMessageWeMediaModel:(MessageWeMediaModel *)messageWeMediaModel{
    _titleLabel.text = messageWeMediaModel.title;
    _nameLabel.text = messageWeMediaModel.nick_name;
    _dateLabel.text = messageWeMediaModel.add_time;
    NSString *imageStr = [@"http://www.hahahuyu.com/" stringByAppendingString:messageWeMediaModel.img_path];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"placeImg"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
