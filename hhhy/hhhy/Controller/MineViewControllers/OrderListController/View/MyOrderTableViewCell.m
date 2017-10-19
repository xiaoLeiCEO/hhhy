//
//  MyOrderTableViewCell.m
//  freeBill
//
//  Created by 张梦川 on 16/12/5.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "CommonUrl.h"
#import "UIImageView+WebCache.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setOrderlistModel:(OrderListModel *)orderlistModel{
    _orderlistModel = orderlistModel;
    _goodsNameLb.text = orderlistModel.title;
    NSArray *orderTypeArr = @[@"发布押金",@"报名费",@"赞助",@"工资余额",@"余额兑换",@"打赏",@"线上充值",@"线下充值",@"奖金池基础奖金",@"推广奖金",@"退还发布押金",@"开通应用",@"抢红包",@"权限购买",@"订单支付",@"PK押金",@"投注"];
    for (int i=1;i<17;i++){
        if ([orderlistModel.goods_type isEqualToString:[NSString stringWithFormat:@"%d",i]]){
            _orderTypeLb.text = [NSString stringWithFormat:@"订单类型: %@",orderTypeArr[i-1]];
        }
    }
    [_goodsThumbImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,orderlistModel.poster]]];
    _orderNumLb.text = [NSString stringWithFormat:@"订单编号%@",orderlistModel.order_sn];
    _goodsPriceLb.text = [NSString stringWithFormat:@"￥%@",orderlistModel.price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
