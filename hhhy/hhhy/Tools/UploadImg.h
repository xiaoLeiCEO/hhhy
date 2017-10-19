//
//  UploadImg.h
//  cloudsmall
//
//  Created by 张梦川 on 15/7/30.
//  Copyright (c) 2015年 simpleway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonUrl.h"
#import "AFNetworking/AFNetworking.h"
#import <Photos/Photos.h>

typedef void (^successBlock)(id responseObject);
typedef void (^failureBlock)(NSError *error);
typedef void (^progressBlock)(NSProgress * uploadProgress);
typedef void (^compressedSuccessBlock)(BOOL isSuccess);


@interface UploadImg : NSObject
// 图片上传方法
+ (NSDictionary *)uploadImageWithUrl:(NSString *)url image:(UIImage *)image errorCode:(NSString **)errorCode errorMsg:(NSString **)errorMsg;

+(void)uploadImage:(UIImage *)img withUrl:(NSString *)imageUrl withParameters:(NSDictionary *)parameters withImageName:(NSString *)imageName;

//多图上传
+(void)uploadImage:(NSArray *)imgData withUrl:(NSString *)imageUrl withParameters:(NSDictionary *)parameters withImageName:(NSString *)imageName successBlock: (successBlock)success;

//检查 App 是否有照片操作授权
+(BOOL)photosAuthority;
//上传视频
+(void)uploadVideo: (NSString *)uploadVideoUrl withVideoPath:(NSString *)videoPath withParameters:(NSDictionary *)parameters withVideoName:(NSString *)videoName progress:(progressBlock)progress success:(successBlock)success  failure:(failureBlock)failure;
//压缩视频,转为mp4格式
+(void)compressedVideo:(AVAsset *)asset success:(compressedSuccessBlock)isSuccess;
//取消压缩
+(void)cancelCompressVideo;
//获得设备是否有访问相机权限
+(BOOL)getCameraRecordPermisson;
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

@end
