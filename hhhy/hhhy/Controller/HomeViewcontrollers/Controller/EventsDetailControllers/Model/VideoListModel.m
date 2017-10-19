//
//  VideoListModel.m
//  hhhy
//
//  Created by 王长磊 on 2017/8/2.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "VideoListModel.h"

@implementation VideoListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]){
        _descri = value;
    }
}
@end
