//
//  MyOrderTableViewCell.h
//  freeBill
//
//  Created by 张梦川 on 16/12/5.
//  Copyright © 2016年 mianlegedan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

@interface MyOrderTableViewCell : UITableViewCell
@property (nonatomic,strong) OrderListModel *orderlistModel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsThumbImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLb;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLb;

@end
