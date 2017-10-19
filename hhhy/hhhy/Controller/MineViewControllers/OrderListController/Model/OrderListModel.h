//
//  OrderListModel.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/20.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject
@property (nonatomic,copy) NSString *order_sn;
@property (nonatomic,copy) NSString *pay_status;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *goods_type;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *poster;

@end
