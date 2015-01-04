//
//  AppUtil.m
//  Login
//
//  Created by Ralbatr Yi on 15-1-4.
//  Copyright (c) 2015年 Ralbatr Yi. All rights reserved.
//

#import "AppUtil.h"

#define mUserDefaults       [NSUserDefaults standardUserDefaults]
@implementation AppUtil
//保存
+(void)userDefaultsSetValue:(NSString*)value withKey:(NSString *)key
{
    NSUserDefaults *tmp = mUserDefaults;
    if (tmp) {
        [tmp setObject:value forKey:key];
        [tmp synchronize];
    }
}

//取出
+(NSString *)userDefaultsGetValue:(NSString *)key
{
    NSString *rtn = nil;
    NSUserDefaults *tmp = mUserDefaults;
    if (tmp) {
        rtn = [tmp objectForKey:key];
    }
    return rtn;
}

+ (BOOL)checkTel:(NSString *)mobileNo
{
    /**
     * 新增手机号码
     * 移动：152,183,184,157,147,178
     * 联通：145,176
     * 电信：181,177
     */
    NSString * NEW = @"^1(4[57]|5[27]|8[134]|7[678])\\d{8}$";
    
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188  ,152,183,184,157,147,178
     * 联通：130,131,132,152,155,156,185,186 ,152,145,176
     * 电信：133,1349,153,180,189  ,181,177
     */
    
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestnew = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NEW];
    
    if (([regextestmobile evaluateWithObject:mobileNo] == YES)
        || ([regextestcm evaluateWithObject:mobileNo] == YES)
        || ([regextestct evaluateWithObject:mobileNo] == YES)
        || ([regextestcu evaluateWithObject:mobileNo] == YES)
        || ([regextestnew evaluateWithObject:mobileNo] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }

}
#pragma mark - 把字典转换为data
+ (NSMutableData *)dictionaryTodata:(NSDictionary *)dic
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dic forKey:kdateKey];
    [archiver finishEncoding];
    return data;
}
#pragma mark - 写入到keychain
+ (BOOL)writeToKeychain:(NSMutableData *)date
{
    NSError *error;
    [SSKeychain setPasswordData:date forService:kService account:@"account" error:&error];
    if (error != nil) {
        NSLog(@"erro is %@",error);
        return NO;
    }else
        return YES;
}
#pragma mark - 读取keychain
+ (BOOL)isExistKeychain
{
    NSData *data = [SSKeychain passwordDataForService:kService account:@"account"];
    if(data != nil) return YES;
    else    return NO;
}
+(UIColor *)colorWithHexColorString:(NSString *)hexColorString
{
    if ([hexColorString length] <6){//长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString=[hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]){//检查开头是0x
        tempString = [tempString substringFromIndex:2];
    }else if ([tempString hasPrefix:@"#"]){//检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] !=6){
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range;
    range.location =0;
    range.length =2;
    NSString *rString = [tempString substringWithRange:range];
    range.location =2;
    NSString *gString = [tempString substringWithRange:range];
    range.location =4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    return [UIColor colorWithRed:((float) r /255.0f)
                           green:((float) g /255.0f)
                            blue:((float) b /255.0f)
                           alpha:1.0f];
}
@end
