//
//  ViewMacro.h
//  hhhy
//
//  Created by 王长磊 on 2017/6/30.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//
#import <UIKit/UIKit.h>


#ifndef ViewMacro_h
#define ViewMacro_h
#define scale_screen [UIScreen mainScreen].scale

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ThemeColor RGBColor(32,233,202)

#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

#endif /* ViewMacro_h */
