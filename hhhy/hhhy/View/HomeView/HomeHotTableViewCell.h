//
//  HomeHotTableViewCell.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/15.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeHotModel.h"

@interface HomeHotTableViewCell : UITableViewCell
@property (nonatomic,strong) HomeHotModel *homeHotModel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *closeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;

@end
