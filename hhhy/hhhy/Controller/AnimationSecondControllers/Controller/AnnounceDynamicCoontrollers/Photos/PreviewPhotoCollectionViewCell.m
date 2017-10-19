//
//  PreviewPhotoCollectionViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/28.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "PreviewPhotoCollectionViewCell.h"

@implementation PreviewPhotoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
    }
    return self;
}


@end
