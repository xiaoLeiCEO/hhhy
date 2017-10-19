//
//  TransactionTableViewCell.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/31.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionModel.h"

@interface TransactionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (nonatomic,strong) TransactionModel *transactionModel;
@end
