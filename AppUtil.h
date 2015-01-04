//
//  AppUtil.h
//  Login
//
//  Created by Ralbatr Yi on 15-1-4.
//  Copyright (c) 2015年 Ralbatr Yi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtil : NSObject

+(void)userDefaultsSetValue:(NSString*)value withKey:(NSString *)key;

+(NSString *)userDefaultsGetValue:(NSString *)key;

+ (BOOL)isLogin;


+ (BOOL)isExistKeychain;

+ (NSMutableData *)dictionaryTodata:(NSDictionary *)dic;

+ (BOOL)writeToKeychain:(NSMutableData *)date;

+ (BOOL)checkTel:(NSString *)mobileNo;

+(UIColor *)colorWithHexColorString:(NSString *)hexColorString;

@end
