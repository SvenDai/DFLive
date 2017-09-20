//
//  DFPlayerManager.h
//  DFLive
//
//  Created by daifeng on 2017/9/19.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFPlayerStatusModel.h"
@class DFPlayerManager;

typedef NS_ENUM(NSInteger,DFPlayerState){
    DFPlayerStateUnKnow,        //为初始化
    DFPlayerStateFailed,        //播放失败（无网络，视频地址错误）
    DFPlayerStateReadyToPlay,   //可以播放了
    DFPlayerStateBuffering,     //缓冲中
    DFPlayerStatePlaying,       //播放中
    DFPlayerStatePause,         //暂停
    DFPlayerStateStoped         //播放停止（需要重新初始化）
    
};

@protocol DFPlayerManagerDelegate <NSObject>

/**
 视频状态改变时

 @param state 状态
 */
-(void) changePlayerState:(DFPlayerState)state;

/**
 播放进度改变时

 @param progress 范围：0~1
 @param second 原秒数
 */
-(void) changePlayerProgress:(double)progress second:(CGFloat)second;

/**
 缓冲状态改变时

 @param progress 范围：0~1
 @param second 原秒数
 */
-(void) changeLoadProgress:(double)progress sencond:(CGFloat)second;

/**
 当缓冲到可以再次播放时

 @param playerMgr 播放器管理实例
 */
-(void) didBuffer:(DFPlayerManager*)playerMgr;

/**
 播放器准备开始播放
 */
-(void) playerReadyToPlay;

@end

@interface DFPlayerManager : NSObject

/**
 播放器布局视图
 */
@property(nonatomic,strong,readonly) UIView *playerLayerView;

/**
 视频时长 /s
 */
@property(nonatomic,assign,readonly) double duration;

/**
 视频当前播放时间 /s
 */
@property(nonatomic,assign,readonly) double currentTime;

/**
 播放器当前状态
 */
@property(nonatomic,assign,readonly) DFPlayerState state;

/**
 从xx秒开始播放视频
 */
@property(nonatomic,assign) NSInteger seekTime;

/**
 实例化

 @param delegate 代理
 @param playerStatusModel 播放器状态模型
 @return 播放器管理对象
 */
+(instancetype) playerManagerWithDelegate:(id<DFPlayerManagerDelegate>)delegate playerStatusModel:(DFPlayerStatusModel*)playerStatusModel;

/**
 初始化播放器

 @param url 播放链接
 */
-(void) initPlayerWithUrl:(NSURL*)url;

/**
 播放
 */
-(void) play;

/**
 重播
 */
-(void) replay;

/**
 暂停
 */
-(void) pause;

/**
 停止
 */
-(void) stop;

/**
 从xx开始播放视频跳转

 @param drageSeconds 视频跳转秒数
 @param completionHandler 完成之后的操作
 */
-(void) seekToTime:(NSInteger) drageSeconds completionHandler:(void(^)())completionHandler;

/**
 改变音量

 @param value 音量值
 */
-(void) changeVolume:(CGFloat)value;

@end
