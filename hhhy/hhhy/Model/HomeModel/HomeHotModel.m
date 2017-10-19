//
//  HomeHotModel.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/15.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "HomeHotModel.h"

@implementation HomeHotModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]){
        self.eventsId = value;
    }
}
@end
