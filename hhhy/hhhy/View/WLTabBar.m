//
//  WLTabBar.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "WLTabBar.h"

@interface WLTabBar()
@property (nonatomic,strong) UIButton *composeButton;//TabBar中间的撰写按钮

@end

@implementation WLTabBar


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.tintColor = [UIColor colorWithRed:26/255.0 green:188/255.0 blue:163/255.0 alpha:1];
    [self addSubview:self.composeButton];
    
    return  self;
}
//设置TabBar的子控件
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat tabBarW = [UIScreen mainScreen].bounds.size.width / 5;
    
    int index = 0;
    
    UIView *tabbar = [[UIView alloc]init];
    
    for (tabbar in self.subviews) {
        //如果TabBar子控件类型是UITabBarButton,这里是判断的关键
        Class class = NSClassFromString(@"UITabBarButton");
        if ([tabbar isKindOfClass:class]) {
            
            //给类型属于UITabBarButton设置frame.高一定不能写0
            tabbar.frame = CGRectMake(tabBarW * index, 0, tabBarW, self.bounds.size.height);
            index ++;
            //因为中间的撰写按钮不属于UITabBarButton类,所以要另进行判断
            if (index == 2) {
                index ++;
            }
        }
    }
    
    self.composeButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 15);
}

//响应触摸事件，如果触摸位置位于圆形按钮控件上，则由圆形按钮处理触摸消息
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //判断tabbar是否隐藏
    if (self.hidden == NO) {
        if ([self touchPointInsideCircle:self.composeButton.center radius:30 targetPoint:point]) {
            //如果位于圆形按钮上，则由圆形按钮处理触摸消息
            return self.composeButton;
        }
        else{
            //否则系统默认处理
            return [super hitTest:point withEvent:event];
        }
    }
    return [super hitTest:point withEvent:event];
}

- (BOOL)touchPointInsideCircle:(CGPoint)center radius:(CGFloat)radius targetPoint:(CGPoint)point
{
    CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) +
                         (point.y - center.y) * (point.y - center.y));
    return (dist <= radius);
}



#pragma  mark -- 对撰写按钮懒加载
-(UIButton *)composeButton{
    if (_composeButton == nil) {
        _composeButton = [[UIButton alloc]init];
        //设置背景图
//        [_composeButton setBackgroundImage:[UIImage imageNamed:@"centerBar"] forState:UIControlStateNormal];
        
//        [_composeButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        //设置图片
        [_composeButton setImage:[UIImage imageNamed:@"centerBar"] forState:UIControlStateNormal];
//        [_composeButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        
        [_composeButton sizeToFit];
        
        //点击事件
        [_composeButton addTarget:self action:@selector(composeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _composeButton;
}

#pragma mark --撰写按钮的点击事件

-(void)composeButtonClick: (UIButton *)send{
    //最好要判断一下block
    if (self.composeButtonBlock) {
        //将按钮添加到block中
        self.composeButtonBlock(@[send]);
    }
}

@end
