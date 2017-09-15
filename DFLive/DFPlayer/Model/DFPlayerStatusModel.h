//
//  DFPlayerStatusModel.h
//  DFLive
//
//  Created by daifeng on 2017/9/14.
//  Copyright © 2017年 fdai. All rights reserved.
//  播放状态的模型

#import <Foundation/Foundation.h>

@interface DFPlayerStatusModel : NSObject
/**
 是否自动播放
 */
@property(nonatomic,assign,getter=isAutoPlay) BOOL autoPlay;
/**
 是否被用户暂停
 */
@property(nonatomic,assign,getter=isPauseBuUser) BOOL pauseByUser;
/**
 是否播放结束
 */
@property(nonatomic,assign,getter=isPlayDidEnd) BOOL playDidEnd;
/**
 是否进入后台
 */
@property(nonatomic,assign,getter=isDisEnterBackground) BOOL didEnterBackground;
/**
 是否在拖拽进度条
 */
@property(nonatomic,assign,getter=isDragged) BOOL dragged;
/**
 是否全屏
 */
@property(nonatomic,assign, getter=isFullScreen) BOOL fullScreen;
/**
 重置状态模型的各个属性
 */
-(void)playerResetStatusModel;

@end
