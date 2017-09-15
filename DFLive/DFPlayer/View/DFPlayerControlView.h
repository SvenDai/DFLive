//
//  DFPlayerControlView.h
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPortraitControlView.h"
#import "DFLandScapeControlView.h"
@class DFPlayerStatusModel;

@protocol DFPlayerControlViewDelegate <NSObject>

/**
 失败按钮被点击
 */
-(void) failButtonClick;

/**
 重播按钮被点击
 */
-(void) repeateButtonClick;

/**
 跳转播放按钮被点击
 @param viewTime 播放时间
 */
-(void) jumpPlayButtonClick:(NSInteger)viewTime;

@end

@interface DFPlayerControlView : UIView

@property(nonatomic,weak) id<DFPlayerControlViewDelegate> delegate;

/**
 是否显示了控制层
 */
@property(nonatomic,assign, getter=isShowing,readonly) BOOL showing;

/**
 竖屏时的控制视图
 */
@property(nonatomic,strong) DFPortraitControlView *portraitControlView;

/**
 横屏时的控制视图
 */
@property(nonatomic,strong) DFLandScapeControlView *landScapeControlView;

/**
 观看时间
 */
@property(nonatomic,assign) NSInteger viewTime;

/**
 实例化一个控制视图

 @param playerStatusModel 播放器状态
 @return 控制视图实例
 */
+(instancetype) playerControlViewWithStatusModel:(DFPlayerStatusModel*)playerStatusModel;

/**
 重置控制视图
 */
-(void) playerResetControlView;
/**
 播放结束隐藏控制视图
 */
-(void) playEndHideControlView;

/**
 开始准备播放
 */
-(void) startReadyToPlay;

/**
 准备播放，隐藏loading视图
 */
-(void) readyToPlay;

/**
 开始加载
 */
-(void) loading;
/**
 加载是被
 */
-(void) loadFailed;

/**
 显示状态栏
 */
-(void) showStatusBar;

/**
 显示控制视图
 */
-(void) showControl;
/**
 隐藏控制视图
 */
-(void) hideControl;

/**
 强行显示控制视图

 @param showing 是否显示
 */
-(void) setIsShowing:(BOOL)showing;

/**
 取消控制层的自动渐退隐藏
 */
-(void) playerCancelAutoFadeOutControlView;

/**
 控制层渐退隐藏
 */
-(void) autoFadeOutControlView;

/**
 显示播放记录

 @param viewTime 播放时间
 */
-(void) showWatchRecordView:(NSInteger)viewTime;

/**
 隐藏播放视图
 */
-(void) hideWatchRecordView;

/**
 显示快进视图

 @param draggedTime 拖拽的长度
 @param totalTime 总时长
 @param forward 向前/后
 */
-(void) showFastView:(NSInteger)draggedTime totalTime:(NSInteger) totalTime isForward:(BOOL)forward;

/**
 隐藏快进视图
 */
-(void) hideFastView;

/**
 播放结束
 */
-(void) playDidEnd;
@end
