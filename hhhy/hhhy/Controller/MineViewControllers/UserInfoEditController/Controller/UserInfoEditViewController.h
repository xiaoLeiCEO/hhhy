//
//  UserInfoEditViewController.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/18.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "BaseViewController.h"

@protocol UserInfoEditViewControllerDelegate <NSObject>

-(void)sendMessage:(NSString *)message;

@end

@interface UserInfoEditViewController : BaseViewController

@property (nonatomic,strong) id<UserInfoEditViewControllerDelegate> delegate;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString *defaultText;

@end
