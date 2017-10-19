//
//  EventsModel.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/17.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "EventsModel.h"

@implementation EventsModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]){
        _eventsId = value;
    }
}
@end
