//
//  UploadPictureViewController.h
//  hhhy
//
//  Created by 王长磊 on 2017/8/21.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "BaseViewController.h"

@interface UploadPictureViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *writeTf;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (nonatomic,copy) NSString *albumId;
@property (nonatomic,copy) NSArray *imageArr;
@end
