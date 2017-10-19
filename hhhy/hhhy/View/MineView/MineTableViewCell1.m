//
//  MineTableViewCell1.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/18.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "MineTableViewCell1.h"

@implementation MineTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setHeadImageView:(UIImageView *)headImageView{
    headImageView.userInteractionEnabled = YES;
    headImageView.clipsToBounds = YES;
    headImageView.layer.cornerRadius = headImageView.frame.size.height/2;
    _headImageView = headImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
