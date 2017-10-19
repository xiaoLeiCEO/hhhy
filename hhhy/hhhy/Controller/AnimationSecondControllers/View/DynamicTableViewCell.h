//
//  DynamicTableViewCell.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/10.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"

@protocol DynamicTableViewCellDelegate <NSObject>

-(void)showPreviewPhotosViewController:(NSArray *)arr withIndex:(NSInteger)index;

@end

@interface DynamicTableViewCell : UITableViewCell{
  @public  CGFloat dynamicHeight;
}

@property (nonatomic,strong) id <DynamicTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLaterLabel;
@property (nonatomic,strong) UIImageView *contentImageView;
@property (nonatomic,strong) DynamicModel *dynamicModel;
@end
