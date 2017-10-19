//
//  HomeCategoryTableViewCell.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/15.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeCategoryTableViewCellDelegate <NSObject>

-(void)sendButtonForAnimationViewTag:(NSInteger)tag;

@end
@interface HomeCategoryTableViewCell : UITableViewCell
@property (nonatomic,strong) id<HomeCategoryTableViewCellDelegate> delegate;
@end
