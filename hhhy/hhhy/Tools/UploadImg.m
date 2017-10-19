//
//  UploadImg.m
//  cloudsmall
//
//  Created by 张梦川 on 15/7/30.
//  Copyright (c) 2015年 simpleway. All rights reserved.
//

#import "UploadImg.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "ImageHelper.h"

static AVAssetExportSession *exportSession;


@implementation UploadImg


// 上传图片
// 图片上传方法
+ (NSDictionary *)uploadImageWithUrl:(NSString *)url image:(UIImage *)image errorCode:(NSString **)errorCode errorMsg:(NSString **)errorMsg {
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    
    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\n",fileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    // 发送数据
    NSURLResponse *response;
    NSError *error;
    
    NSData *rspData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //     NSData *rspData = [NSURLSession ]
    if (rspData == nil || error) {
        *errorCode = @"HttpError";
        *errorMsg = @"网络数据异常";
        
        return nil;
    }
    
    // JSON解析
    NSError *jsonError;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:rspData options:NSJSONReadingMutableContainers error:&jsonError];
    if (result == nil || jsonError) {
        *errorCode = @"JsonError";
        *errorMsg = jsonError ? [NSString stringWithFormat:@"%@", [jsonError domain]] : @"JsonError";
        
        return nil;
    }
    
    return result;
}



+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (!data){
        //        CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
        //        data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(newImage, 1);
    }
    else {
        return data;
    }
    NSLog(@"%@", data);
    
    //    if (data.length < maxLength) return data;
    //
    //    CGFloat max = 1;
    //    CGFloat min = 0;
    //    for (int i = 0; i < 6; ++i) {
    //        compression = (max + min) / 2;
    //        data = UIImageJPEGRepresentation(image, compression);
    //        if (data.length < maxLength * 0.9) {
    //            min = compression;
    //        } else if (data.length > maxLength) {
    //            max = compression;
    //        } else {
    //            break;
    //        }
    //    }
    //    UIImage *resultImage = [UIImage imageWithData:data];
    //    if (data.length < maxLength) return data;
    //
    //    // Compress by size
    //    NSUInteger lastDataLength = 0;
    //    while (data.length > maxLength && data.length != lastDataLength) {
    //        lastDataLength = data.length;
    //        CGFloat ratio = (CGFloat)maxLength / data.length;
    //        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
    //                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
    //        UIGraphicsBeginImageContext(size);
    //        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //        resultImage = UIGraphicsGetImageFromCurrentImageContext();
    //        UIGraphicsEndImageContext();
    //        data = UIImageJPEGRepresentation(resultImage, compression);
    //    }
    
    return data;
}

//检查 App 是否有照片操作授权
+(BOOL)photosAuthority {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
        return NO;
    }
    else{
        return YES;
    }
}

//获得设备是否有访问相机权限
+(BOOL)getCameraRecordPermisson
{
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;
}

//压缩视频,转为mp4格式，并上传
+(void)compressedVideo:(AVAsset *)asset success:(compressedSuccessBlock)isSuccess{
    
    //            NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    //            [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    
    NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output.mp4"];
    NSLog(@"%@",resultPath);
    if ([[NSFileManager defaultManager]fileExistsAtPath:resultPath]){
        [[NSFileManager defaultManager] removeItemAtPath:resultPath error:nil];
    }
    
    
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
    {
       exportSession = [[AVAssetExportSession alloc]initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                //压缩视频成功
                isSuccess(YES);
                
            }else{
                isSuccess(NO);
            }
        }];
        
    }
    
}

//取消视频压缩
+(void)cancelCompressVideo{
    [exportSession cancelExport];
}

//上传视频
+(void)uploadVideo: (NSString *)uploadVideoUrl withVideoPath:(NSString *)videoPath withParameters:(NSDictionary *)parameters withVideoName:(NSString *)videoName progress:(progressBlock)progress success:(successBlock)success  failure:(failureBlock)failure {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    
    [manager POST:uploadVideoUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:videoPath]];
        [formData appendPartWithFileData:data name:videoName fileName:fileName mimeType:@"video/mpeg4"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // JSON解析
        NSError *jsonError;
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* strdata = [[NSString alloc]initWithData:responseObject encoding:enc];//在将NSString类型转为NSData
        NSData * data = [strdata dataUsingEncoding:NSUTF8StringEncoding];//这样解决的乱码问题。
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError ];
        if (success){
            success(json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

//单图上传
+(void)uploadImage:(UIImage *)img withUrl:(NSString *)imageUrl withParameters:(NSDictionary *)parameters withImageName:(NSString *)imageName {
    //截取图片
    NSLog(@"%@", img);
    
    NSData *imageData = [self compressImage:img toByte:5000000];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    
    // 访问路径
    NSString *stringURL = [NSString stringWithFormat:@"%@",imageUrl];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:stringURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传文件
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        if (imageData){
            
            [formData appendPartWithFileData:imageData name:imageName fileName:fileName mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        [self showHUDmessage:@"上传中"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // JSON解析
        NSError *jsonError;
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* strdata = [[NSString alloc]initWithData:responseObject encoding:enc];//在将NSString类型转为NSData
        NSData * data = [strdata dataUsingEncoding:NSUTF8StringEncoding];//这样解决的乱码问题。
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError ];
        NSLog(@"%@", json);
        if ([json[@"status"] isEqualToString:@"1"]){
            NSLog(@"上传成功");
            NSLog(@"%@", json[@"msg"]);
        }
        else {
            NSLog(@"上传失败");
            NSLog(@"%@", json[@"msg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传错误");
    }];
    
}


//多图上传
+(void)uploadImage:(NSArray *)imgData withUrl:(NSString *)imageUrl withParameters:(NSDictionary *)parameters withImageName:(NSString *)imageName successBlock: (successBlock)success {
    //截取图片

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    
    // 访问路径
    NSString *stringURL = [NSString stringWithFormat:@"%@",imageUrl];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:stringURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传文件
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        NSInteger imgCount = 0;
        
        for (NSData *imageData  in imgData) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
            
            NSString *fileName = [NSString stringWithFormat:@"%@%@.jpg",[formatter stringFromDate:[NSDate date]],@(imgCount)];
            
            if (imageData){
                
                [formData appendPartWithFileData:imageData name:imageName fileName:fileName mimeType:@"image/jpeg"];
                
            }
            
            imgCount++;
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        [self showHUDmessage:@"上传中"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // JSON解析
        NSError *jsonError;
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* strdata = [[NSString alloc]initWithData:responseObject encoding:enc];//在将NSString类型转为NSData
        NSData * data = [strdata dataUsingEncoding:NSUTF8StringEncoding];//这样解决的乱码问题。
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError ];
        if (success){
            success(json);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传错误");
    }];
    
}



@end
