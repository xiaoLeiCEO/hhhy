//
//  PlayerListTableViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/8/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "PlayerListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommonUrl.h"
@implementation PlayerListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setPayerListModel:(PlayerListModel *)payerListModel{
    _payerListModel = payerListModel;
    _nickNameLb.text = payerListModel.nick_name ;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,payerListModel.photo]]];
}

-(UIImageView *)headImageView{
    if (_headImageView){
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = _headImageView.frame.size.height/2;
    }
    return _headImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
