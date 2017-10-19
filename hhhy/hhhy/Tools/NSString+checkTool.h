//
//  NSString+checkTool.h
//  hhhy
//
//  Created by 王长磊 on 2017/7/5.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (checkTool)
//判断字符串是否为空
-(BOOL)isEmpty;
//邮箱格式是否正确
-(BOOL)isUsableEmail;
//手机号格式是否正确
-(BOOL)isUsableMobile;
//匹配用户密码6-18位数字和字母组合
-(BOOL)isUsablePassword;
@end
