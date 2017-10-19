//
//  SecondAddPhotosViewController.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/27.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "BaseViewController.h"

@protocol SencondAddPhotosViewControllerDelegate <NSObject>

-(void)sendMessage:(NSString *)message;

@end

@interface SecondAddPhotosViewController : BaseViewController

@property (nonatomic,assign) BOOL isAuthority;
@property (nonatomic,strong) id<SencondAddPhotosViewControllerDelegate> delegate;
@end
