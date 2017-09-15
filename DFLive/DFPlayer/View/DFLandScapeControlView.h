//
//  DFLandScapeControlView.h
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//  横屏时的控制视图

#import <UIKit/UIKit.h>

@protocol DFLandScapeControlViewDelegate <NSObject>

/**
 返回按钮被点击
 */
-(void)landScapeBackButtonClick;

/**
 播放/暂停按钮被点击
 @param isSelected 是否被选中
 */
-(void)landScapePlayPauseButtonClick:(BOOL)isSelected;

/**
 发送弹幕按钮被点击
 */
-(void)landScapeSendBarrageButtonClick;

/**
 弹幕开关按钮被点击
 @param isSelected 是否选中
 */
-(void)landScapeOpenOrCloseBarrageButtonClick:(BOOL)isSelected;

/**
 进度条开始被拖动
 */
-(void)landScapeProgressSliderBeginDrag;

/**
 进度条拖动结束
 */
-(void)landScapeProgressSliderEndDrag:(CGFloat)value;

/**
 退出全屏按钮被点击
 */
-(void)landScapeExitFullScreenButtonClick;

/**
 进度条tap事件
 @param value tap时的值
 */
-(void)landScapeProgressSliderTapAction:(CGFloat)value;

@end

@interface DFLandScapeControlView : UIView
@property(nonatomic,weak) id<DFLandScapeControlViewDelegate> delegate;

/**
 重置控制视图
 */
-(void)playerResetControlView;

/**
 播放结束隐藏控制视图
 @param playEnd 播放结束
 */
-(void)playerEndHideView:(BOOL)playEnd;

/**
 更新标题
 @param title 标题
 */
-(void)syncTitle:(NSString*)title;

/**
 更新播放/暂停按钮
 @param isPlay 是否播放
 */
-(void)syncPlayPauseButton:(BOOL)isPlay;

/**
 更新弹幕开关按钮
 @param isOpen 是否开着
 */
-(void)syncOpenCloseBarrageButton:(BOOL)isOpen;

/**
 更新缓冲进度
 @param progress 缓冲进度值
 */
-(void)syncBufferProgress:(double)progress;

/**
 更新播放进度值
 @param progress 播放进度值
 */
-(void)syncPlayProgress:(double)progress;

/**
 更新播放时间
 @param time 播放时间
 */
-(void)syncPlayTime:(NSInteger)time;

/**
 更新视频总时长
 @param time 时长
 */
-(void)syncDurationTime:(NSInteger)time;


@end
