//
//  DynamicModel.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/10.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicModel : NSObject
@property (copy,nonatomic) NSString* add_time;
@property (copy,nonatomic) NSString* content;
@property (strong,nonatomic) NSArray* img_list;
@property (copy,nonatomic) NSString* nick_name;
@property (copy,nonatomic) NSString* photo;
@property (copy,nonatomic) NSString* user_id;
@property (copy,nonatomic) NSString* title;

@end
