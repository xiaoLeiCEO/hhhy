//
//  RewardView.m
//  hhhy
//
//  Created by 王长磊 on 2017/8/14.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "RewardView.h"

@implementation RewardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    _moneyView.layer.masksToBounds = YES;
    _moneyView.layer.cornerRadius = 50;
}



@end
