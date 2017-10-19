//
//  MessageCollectionViewCell.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/4.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageCollectionViewCellDelegate <NSObject>

-(void)pushMessageDetailViewController:(NSString *)urlString withUserId:(NSString *)userId;
    


@end

@interface MessageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) id<MessageCollectionViewCellDelegate> delegate;

@end
