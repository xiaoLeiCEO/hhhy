//
//  AnimtaionView.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/7.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "AnimtaionView.h"

@implementation AnimtaionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];        
        _label = [[UILabel alloc]init];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        [self addSubview:_btn];
    }
    return self;
}

@end
