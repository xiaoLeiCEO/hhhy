//
//  TicketTableViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/20.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "TicketTableViewCell.h"

@implementation TicketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setOrderModel:(OrderModel *)orderModel{
    _orderModel = orderModel;
    if (orderModel.ticket_name){
        _ticketNameLb.text = orderModel.ticket_name;
    }
    else {
        _ticketNameLb.text = orderModel.group_name;

    }
    _ticketPriceLb.text = [NSString stringWithFormat:@"￥%@",orderModel.price];
    _ticketDirectionsLb.text = orderModel.shuoming;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
