//
//  TicketTableViewCell.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/20.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface TicketTableViewCell : UITableViewCell
@property (nonatomic,strong) OrderModel *orderModel;

@property (weak, nonatomic) IBOutlet UILabel *ticketNameLb;
@property (weak, nonatomic) IBOutlet UILabel *ticketDirectionsLb;
@property (weak, nonatomic) IBOutlet UILabel *ticketPriceLb;

@end
