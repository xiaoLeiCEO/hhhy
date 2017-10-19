//
//  PayOrderView.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/21.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payMoneyBtn;

@end
