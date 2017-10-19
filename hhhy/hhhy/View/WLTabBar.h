//
//  WLTabBar.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^myBlock) (NSArray *composeButton);//给block起别名,用数组来存放点击的Button

@interface WLTabBar : UITabBar
@property (nonatomic,strong) myBlock composeButtonBlock;//定义block

@end
