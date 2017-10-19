//
//  UserInfo.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/5.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
//存储用户是否登录
+(void)setIsLogin:(BOOL)islogin{
    [userDefaults setBool:islogin forKey:@"isLogin"];
}
//存储用户密码
+(void)setPassword:(NSString *)password {
    [userDefaults setObject:password forKey:@"password"];
}
//存储用户账号
+(void)setAccount:(NSString *)account{
    [userDefaults setObject:account forKey:@"account"];
}
//存储token
+(void)setToken:(NSString *)token{
    [userDefaults setObject:token forKey:@"token"];
}
//存储手机号
+(void)setPhoneNum:(NSString *)phoneNum{
    [userDefaults setObject:phoneNum forKey:@"phoneNum"];
}

//存储用户信息
+(void)setUserInfo:(NSDictionary *)userInfoDic{
    [userDefaults setObject:userInfoDic forKey:@"userInfo"];
}
//获取用户信息
+(NSDictionary *)getUserInfo{
    return [userDefaults objectForKey:@"userInfo"];
}

//获取手机号
+(NSString *)getPhoneNum{
    return [userDefaults objectForKey:@"phoneNum"];
}
//获取用户密码
+(NSString *)getPassword{
    return [userDefaults objectForKey:@"password"];
}
//获取用户账号
+(NSString *)getAccount{
    return [userDefaults objectForKey:@"account"];
}
//获取token
+(NSString *)getToken{
    return [userDefaults objectForKey:@"token"];
}
//获取用户是否登录
+(BOOL)isLogin{
    return [userDefaults boolForKey:@"isLogin"];
}

@end
