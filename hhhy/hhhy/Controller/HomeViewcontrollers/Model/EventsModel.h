//
//  EventsModel.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/17.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsModel : NSObject

@property (nonatomic,copy) NSString *is_collection; //是否收藏
@property (nonatomic,copy) NSString *sign_counts; //报名人数
@property (nonatomic,copy) NSString *limit_num; //最多报名人数
@property (nonatomic,copy) NSString *starttime;
@property (nonatomic,copy) NSString *close_time;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *res1; //收藏次数
@property (nonatomic,copy) NSString *browse_num; //浏览次数
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *poster;
@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *eventsId;

@end
