//
//  NSString+Extension.h
//  新浪微博
//
//  Created by 石冬冬 on 15/11/5.
//  Copyright © 2015年 石冬冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)
/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */

- (CGSize) sizeWithFont:(UIFont *) font maxW:(CGFloat) maxW;
- (CGSize) sizeWithFont:(UIFont *) font;
/**
 *  计算文字的高度
 *
 *  @param value    计算的文字
 *  @param fontSize 文字大小
 *  @param width    宽度
 *
 *  @return 高度
 */
+ (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
+ (float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;

/**
 *  将服务器时间转成字符串
 *
 *  @param timestamp 需要转换的服务器时间
 *  @param format    需要转成的格式
 *
 *  @return 字符串
 */
+ (NSString *)dateFormMoreTimestampString:(NSString *)timestamp format:(NSString *)format;


//词典转json
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/**
 *  汉字的拼音
 *
 *  @return 拼音
 */
- (NSString *)pinyin;
/**
 *  去除两边空格
 */
+ (NSString *)trimString:(NSString *)string;

/**
 *  计算当前日期是星期几
 *
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
@end
