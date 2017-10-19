//
//  WeMediaTableViewCell.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/4.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageWeMediaModel.h"

@interface WeMediaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) MessageWeMediaModel *messageWeMediaModel;
@end
