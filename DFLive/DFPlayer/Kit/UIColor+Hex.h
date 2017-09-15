//
//  UIColor+Hex.h
//  DFLive
//
//  Created by daifeng on 2017/9/12.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DFColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface UIColor (Hex)

// 默认alpha位1
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
