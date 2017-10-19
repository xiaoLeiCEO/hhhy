//
//  OrderModel.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/21.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property (nonatomic,copy) NSString *hd_name;
@property (nonatomic,copy) NSString *shuoming;
@property (nonatomic,copy) NSString *ticket_name;
@property (nonatomic,copy) NSString *group_name;

@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *ticketId;

@end
