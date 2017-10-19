//
//  TransactionModel.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/31.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionModel : NSObject
@property (nonatomic,copy) NSString *order_sn;
@property (nonatomic,copy) NSString *outlay;
@property (nonatomic,copy) NSString *income;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *serial_number;
@property (nonatomic,copy) NSString *name;

@end
