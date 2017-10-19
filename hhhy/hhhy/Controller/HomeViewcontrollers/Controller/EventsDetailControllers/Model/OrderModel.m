//
//  OrderModel.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/21.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]){
        _ticketId = value;
    }
}

@end
