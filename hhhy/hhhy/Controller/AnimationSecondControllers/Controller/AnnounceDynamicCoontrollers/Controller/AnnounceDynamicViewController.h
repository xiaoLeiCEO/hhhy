//
//  AnnounceDynamicViewController.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/11.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "BaseViewController.h"

@interface AnnounceDynamicViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *writeTf;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (nonatomic,assign) BOOL isDynamic;

@end
