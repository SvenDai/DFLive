//
//  DFPlayerModel.m
//  DFLive
//
//  Created by daifeng on 2017/9/14.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFPlayerModel.h"

@implementation DFPlayerModel

-(UIImage *) placeholderImage{
    if (!_placeholderImage) {
        _placeholderImage = [self createImageWithColor:[UIColor blackColor]];
    }
    return _placeholderImage;
}


/**
 通过纯色生成一个图片
 @param color 颜色
 @return 图片
 */
-(UIImage *)createImageWithColor:(UIColor*)color{
    
    UIGraphicsBeginImageContext(CGSizeMake(1.0f, 1.0f));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
