//
//  HomeCategoryTableViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/15.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "HomeCategoryTableViewCell.h"
#import "AnimtaionView.h"
#import "ViewMacro.h"

@implementation HomeCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//tableViewCell在初始化的时候宽高默认是320*44.只有在布局的时候才会调整到设置的高度。所以可以重写layoutSubviews方法。在layoutSubviews里面加载
-(void)layoutSubviews{
    [super layoutSubviews];
//    NSArray *arr = @[@"活动",@"赛事",@"商城",@"招聘",@"更多"];
//    NSArray *array = @[@"huoDong",@"saiShi",@"shangCheng",@"zhaoPin",@"gengDuo"];
//    for (int i=0;i<5;i++){
//        AnimtaionView *animationView = [[AnimtaionView alloc]init];
//        animationView.btn.frame = CGRectMake(0, 0, 50, 50);
//        animationView.label.frame = CGRectMake(0, 50, 50, 21);
//        CGFloat animationViewBtnWidth = animationView.btn.frame.size.width;
//        animationView.frame = CGRectMake(28+i*((screen_width-28*2-50*5)/4+50), 14, animationViewBtnWidth, animationViewBtnWidth + 21);
//        animationView.tag = i + 100;
//        [animationView.btn setBackgroundImage:[UIImage imageNamed:array[i]] forState:normal];
//        animationView.btn.tag = i + 200;
//        animationView.label.text = arr[i];
//        [self.contentView addSubview:animationView];
//        
//    }
    [self createUI];
}


-(void)createUI{
    NSArray *arr = @[@"相册",@"动态",@"日志",@"收藏",@"设置"];
    NSArray *array = @[@"xc",@"dt",@"rz",@"sc",@"shez"];
    for (int i=0;i<5;i++){
        int line = i % 3;
        int row = i / 3;
        AnimtaionView *animationView = [[AnimtaionView alloc]init];
        animationView.btn.frame = CGRectMake(0, 0, 40, 40);
        animationView.label.frame = CGRectMake(0, 40, 40, 21);
        CGFloat animationViewBtnWidth = animationView.btn.frame.size.width;
        animationView.frame = CGRectMake(line*((screen_width-animationViewBtnWidth*3)/3+animationViewBtnWidth)+(screen_width-animationViewBtnWidth*3)/6, 32+row*(40+21+36), animationViewBtnWidth, 40+21);
        animationView.tag = i + 100;
        
        [animationView.btn addTarget:self action:@selector(animationViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];        
        [animationView.btn setBackgroundImage:[UIImage imageNamed:array[i]] forState:normal];
        animationView.btn.tag = i + 200;
        animationView.label.text = arr[i];
        [self.contentView addSubview:animationView];
    }
    
}

-(void)animationViewBtnAction:(UIButton *)sender{
    [_delegate sendButtonForAnimationViewTag:sender.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
