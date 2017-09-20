//
//  DFPlayerVideoPlayer.h
//  DFLive
//
//  Created by daifeng on 2017/9/19.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFPlayerModel.h"

@protocol DFPlayerVideoPlayerDelegate <NSObject>
@optional

/**
 返回按钮被点击
 */
-(void) playerBackButtonClick;

/**
 分享按钮被点击
 */
-(void) playerShareButtonClick;

/**
 控制层封面点击事件
 */
-(void) controlViewTapAction;

/**
 播放完了
 */
-(void) playerDidEndAction;

/**
 快进/快退的回调
 */
-(void) playerSeekTimeAction;

@end


@interface DFPlayerVideoPlayer : NSObject

/**
 被用户暂停
 */
@property(nonatomic,assign,readonly) BOOL isPauseByUser;

/**
 实例化
 @param view 在正常屏幕下的视图位置
 @param delegate 代理
 @param playerModel 播放器模型
 @return 对象
 */
+(instancetype) videoPlayerWithView:(UIView*)view delegate:(id<DFPlayerVideoPlayerDelegate>) delegate playerModel:(DFPlayerModel *) playerModel;

/**
 重置播放器参数（播放新视频的时候调用）

 @param playerModel 播放器模型
 */
-(void) resetToPlayNewVideo:(DFPlayerModel*)playerModel;

/**
 自动播放
 */
-(void) autoPlayTheVideo;

/**
 播放
 */
-(void) playVideo;

/**
 暂停
 */
-(void) pauseVideo;

/**
 停止
 */
-(void) stopVideo;

/**
 销毁
 */
-(void) destroyVideo;

@end
