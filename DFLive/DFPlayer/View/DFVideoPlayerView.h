//
//  DFVideoPlayerView.h
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPlayerControlView.h"
#import "DFCoverControlView.h"
#import "DFLoadingView.h"

@class DFPlayerStatusModel;

@protocol DFVideoPlayerViewDelegate <NSObject>
@optional
/**
 双击事件
 */
-(void) doubleTapAction;
/**
 pan开始水平移动
 */
-(void) panHorizontalBegainMoved;
/**
 pan在移动中
 @param value 移动的值
 */
-(void) panHorizontalMoving:(CGFloat)value;
/**
 水平移动结束
 */
-(void) panHorizontalEndMoved;
/**
 音量改变
 @param value 改变值
 */
-(void) volumeValueChange:(CGFloat)value;

@end

@interface DFVideoPlayerView : UIView
/**
 视频控制层、自定义层
 */
@property(nonatomic,strong,readonly) DFPlayerControlView *playerControlView;
/**
 未播放、封面的View
 */
@property(nonatomic,strong) DFCoverControlView *coverControlView;
/**
 未播放、加载View；
 */
@property(nonatomic,strong) DFLoadingView *loadingView;


/**
 初始化方法

 @param superview 父View
 @param delegate 代理
 @param playerStatusModel 播放器状态模型
 @return 对象
 */
+(instancetype) videoPlayerViewWithSuperView:(UIView*) superview delegate:(id<DFVideoPlayerViewDelegate>)delegate playerStatusModel:(DFPlayerStatusModel*)playerStatusModel;

/**
 设置播放视图

 @param playerLayerView 视图
 */
-(void) setPlayerLayerView:(UIView*)playerLayerView;

/**
 重置播放视图
 */
-(void) playerResetVideoPlayerView;

/**
 开始准备播放
 */
-(void) startReadyToPlay;

/**
 加载失败
 */
-(void) loadFailed;

/**
 设置横屏或者竖屏

 @param isFull 是否全屏
 */
-(void) shrinkOrFullScreen:(BOOL)isFull;

/**
 播放结束
 */
-(void) playDidEnd;

/**
 重播
 */
-(void) repeatPlay;

@end
