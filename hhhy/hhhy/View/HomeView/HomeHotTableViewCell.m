//
//  HomeHotTableViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/15.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "HomeHotTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommonUrl.h"
@implementation HomeHotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setHomeHotModel:(HomeHotModel *)homeHotModel{
    _homeHotModel = homeHotModel;
    _titleLabel.text = homeHotModel.title;
    _addressLabel.text = homeHotModel.address;
    _startTimeLabel.text = [NSString stringWithFormat:@"开始时间: %@",homeHotModel.starttime];
    _closeTimeLabel.text = [NSString stringWithFormat:@"截止时间: %@",homeHotModel.close_time];
    [_posterImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,homeHotModel.poster]]];
    if ([homeHotModel.ticket isEqualToString:@"0"]){
        _chargeLabel.text = @"免费";
    }
    else {
        _chargeLabel.text = @"收费";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
