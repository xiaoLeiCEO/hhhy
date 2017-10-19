//
//  BaseViewController.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/1.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommonUrl.h"
#import "ZMCHttpTool.h"
#import "ViewMacro.h"
#import "UserInfo.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
@interface BaseViewController : UIViewController

-(void)showProgressHud:(MBProgressHUDMode )mode message:(NSString *)msg;

-(void)hideProgressHud;

-(void)hideProgeressHudAfterDelay:(NSTimeInterval) delay;

-(void)showAlert:(NSString *)msg;


@end
