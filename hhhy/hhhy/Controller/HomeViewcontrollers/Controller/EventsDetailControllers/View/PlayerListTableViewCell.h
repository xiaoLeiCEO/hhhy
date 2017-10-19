//
//  PlayerListTableViewCell.h
//  hhhy
//
//  Created by 王长磊 on 2017/8/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerListModel.h"

@interface PlayerListTableViewCell : UITableViewCell

@property (nonatomic,strong) PlayerListModel *payerListModel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;

@end
