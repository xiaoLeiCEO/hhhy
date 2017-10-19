//
//  TransactionTableViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/31.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "TransactionTableViewCell.h"

@implementation TransactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTransactionModel:(TransactionModel *)transactionModel{
    _transactionModel = transactionModel;
    _createTimeLb.text = transactionModel.create_time;
    _nameLb.text = transactionModel.name;
    if (transactionModel.income.integerValue==0){
        _moneyLb.text = [NSString stringWithFormat:@"-%@",transactionModel.outlay];
        _moneyLb.textColor = [UIColor blackColor];
    }
    else {
        _moneyLb.text = [NSString stringWithFormat:@"+%@",transactionModel.income];
        _moneyLb.textColor = [UIColor redColor];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
