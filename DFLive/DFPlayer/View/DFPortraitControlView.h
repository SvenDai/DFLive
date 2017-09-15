//
//  DFPortraitControlView.h
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//  竖屏时的控制视图

#import <UIKit/UIKit.h>

@protocol DFPortraitControlViewDelegate <NSObject>

/**
 返回按钮点击事件
 */
-(void) portraitBackButtonClick;

/**
 分享按钮点击事件
 */
-(void) portraitShareButtonClick;

/**
 播放暂停按钮点击事件

 @param isSelected 默认暂停 选中播放
 */
-(void) portraitPlayPuaseButtionClick:(BOOL) isSelected;

/**
 全屏按钮点击事件
 */
-(void) portraitFullScreenButtonClick;

/**
 开始拖拽进度条
 */
-(void) portraitProgressSliderBeginDrag;

/**
 结束拖拽进度条

 @param value 进度条值
 */
-(void) portraitProgressSliderEndDrag:(CGFloat) value;

/**
 进度条tap点击

 @param value tap时的值
 */
-(void) portraitProgressSliderTapAction:(CGFloat) value;

@end

@interface DFPortraitControlView : UIView

@property(nonatomic,strong) id<DFPortraitControlViewDelegate> delegate;

/**
 重置控制层视图
 */
-(void) playerResetControlView;

/**
 播放结束隐藏控制层视图

 @param playEnd 是否播放结束
 */
-(void) playEndHideView:(BOOL)playEnd;

/**
 更新播放/暂停按钮状态

 @param isPlay 是否播放
 */
-(void) syncPlayPauseButton:(BOOL)isPlay;

/**
 更新缓冲进度

 @param progress 缓冲进度值
 */
-(void) syncBufferProgress:(double)progress;

/**
 更新播放进度

 @param progress 播放进度
 */
-(void) syncPlayProgress:(double)progress;

/**
 更新播放时间

 @param time 时间值
 */
-(void) syncPlayTime:(NSInteger)time;

/**
 更新视频的时长

 @param time 时长
 */
-(void) syncDurationTime:(NSInteger)time;

@end
