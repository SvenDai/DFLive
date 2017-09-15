//
//  DFPlayerModel.h
//  DFLive
//
//  Created by daifeng on 2017/9/14.
//  Copyright © 2017年 fdai. All rights reserved.
//  播放视频的模型

#import <Foundation/Foundation.h>

@interface DFPlayerModel : NSObject

/**
 视频标题
 */
@property(nonatomic,copy) NSString  *title;

/**
 视频地址
 */
@property(nonatomic,strong) NSURL   *videoURL;

/**
 视频封面本地图片
 */
@property(nonatomic,strong) UIImage *placeholderImage;

/**
 视频的网络封面
 */
@property(nonatomic,copy) NSString  *placeholderImageURLString;

/**
 视频分辨率
 */
@property(nonatomic,strong) NSDictionary *resolutionDic;

/**
 从指定时间播放视频
 */
@property(nonatomic,assign) NSInteger seekTime;

/**
 上次播放时间
 */
@property(nonatomic,assign) NSInteger viewTime;

/**
 视频ID
 */
@property(nonatomic,assign) NSInteger VideoId;

@end
