//
//  UserInfo.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/5.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#define userDefaults [NSUserDefaults standardUserDefaults]
@interface UserInfo : NSObject
//存储用户密码
+(void)setPassword:(NSString *)password;
//存储用户账号
+(void)setAccount:(NSString *)account;
//存储token
+(void)setToken:(NSString *)token;
//存储用户是否登录
+(void)setIsLogin:(BOOL)islogin;
//存储手机号
+(void)setPhoneNum:(NSString *)phoneNum;

//存储用户信息
+(void)setUserInfo:(NSDictionary *)userInfoDic;
//获取用户信息
+(NSDictionary *)getUserInfo;
//获取手机号
+(NSString *)getPhoneNum;
//获取用户密码
+(NSString *)getPassword;
//获取用户账号
+(NSString *)getAccount;
//获取token
+(NSString *)getToken;
//获取用户是否登录
+(BOOL)isLogin;
@end
