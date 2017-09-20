//
//  DFPlayerManager.m
//  DFLive
//
//  Created by daifeng on 2017/9/19.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFPlayerManager.h"
#import "IJKMediaFramework/IJKMediaFramework.h"
#import "DFPlayerStatusModel.h"
#import <AVFoundation/AVFoundation.h>

@interface DFPlayerManager ()

@property(nonatomic, weak) id<DFPlayerManagerDelegate> delegate;
//播放器
@property(nonatomic,strong) IJKFFMoviePlayerController *player;
//当前播放器状态
@property(nonatomic,assign) DFPlayerState state;
//定时器
@property(nonatomic,weak) NSTimer *timer;
//播放器参数模型
@property(nonatomic,strong) DFPlayerStatusModel *playerStatusModel;
//声音滑杆
@property(nonatomic,strong) UISlider *volumeViewSlider;
//是否初始化播放过
@property(nonatomic,assign,getter=isInitReadyToPlay) BOOL initReadyToPlay;

@end

@implementation DFPlayerManager

+(instancetype) playerManagerWithDelegate:(id<DFPlayerManagerDelegate>)delegate playerStatusModel:(DFPlayerStatusModel *)playerStatusModel{
    DFPlayerManager *playerMgr = [[DFPlayerManager alloc]init];
    playerMgr.delegate = delegate;
    playerMgr.playerStatusModel = playerStatusModel;
    
    return playerMgr;
}

-(void) dealloc{
    [self.timer invalidate];
    self.timer = nil;
    
    [self removeMovieNotificationObservers];
    [self removeBackgroundNotificationObservers];
    
}

-(void) initPlayerWithUrl:(NSURL *)url{
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    
    self.player.shouldAutoplay = YES;
    [self.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    self->_playerLayerView = self.player.view;
    [self.player prepareToPlay];
    
    self.playerStatusModel.autoPlay = YES;
    self.initReadyToPlay = NO;
    self.playerStatusModel.pauseByUser = NO;
    //设置音量，播放器监听
    [self configureVolume];
    [self addPlayerNotificationObservers];
    [self addBackgroundNotificationObservers];
}

#pragma mark - application enter background observers
-(void) addBackgroundNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void) removeBackgroundNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void) appWillEnterBackground{
    self.playerStatusModel.didEnterBackground = YES;
    self.state = DFPlayerStatePause;
    //暂停
    [self.player pause];
}

-(void) appDidEnterPlayGround{
    self.playerStatusModel.didEnterBackground = NO;
    if (!self.playerStatusModel.isPauseBuUser) {
        self.state = DFPlayerStatePlaying;
        self.playerStatusModel.pauseByUser = NO;
        
        [self play];
    }
}

#pragma mark - getter
-(double) duration{
    return self.player.duration;
}

-(double) currentTime{
    return self.player.currentPlaybackTime;
}
#pragma mark - setter
-(void) setState:(DFPlayerState)state{
    _state = state;
    if ([self.delegate respondsToSelector:@selector(changePlayerState:)]) {
        [self.delegate changePlayerState:state];
    }
}

#pragma mark - 更新缓存和播放进度显示
-(void) update {
    double playProgress = self.player.currentPlaybackTime / self.player.duration;
    
    [self.delegate changePlayerProgress:playProgress second:self.player.currentPlaybackTime];
    
    double loadProgress = self.player.playableDuration / self.player.duration;
    
    [self.delegate changeLoadProgress:loadProgress sencond:self.player.playableDuration];
}

#pragma mark - 增加观察视频播放状态
/**
 准备播放                       IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification;
 尺寸改变发出的通知               IJKMPMoviePlayerScalingModeDidChangeNotification;
 播放完成或者用户退出             IJKMPMoviePlayerPlaybackDidFinishNotification;
 播放完成或者用户退出的原因（key）  IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey; // NSNumber (IJKMPMovieFinishReason)
 播放状态改变了                  IJKMPMoviePlayerPlaybackStateDidChangeNotification;
 加载状态改变了                  IJKMPMoviePlayerLoadStateDidChangeNotification;
 目前不知道这个代表啥             IJKMPMoviePlayerIsAirPlayVideoActiveDidChangeNotification;
 **/

-(void) addPlayerNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark - 视频加载状态改变

/**
 IJKMPMovieLoadStateUnknown == 0
 IJKMPMovieLoadStatePlayable == 1
 IJKMPMovieLoadStatePlaythroughOK == 2
 IJKMPMovieLoadStateStalled == 4
 */
-(void) loadStateDidChange:(NSNotification*)notification{
    IJKMPMovieLoadState loadState = self.player.loadState;
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        //加载完成，即将播放，停止加载动画 并将其移除
        DebugLog(@"加载完成，即将播放，加载状态：%d",(int)loadState);
        
        self.state = DFPlayerStateReadyToPlay;
        if (!self.isInitReadyToPlay) {
            self.initReadyToPlay = YES;
            
            if ([self.delegate respondsToSelector:@selector(playerReadyToPlay)]) {
                [self.delegate playerReadyToPlay];
            }
            
            if (self.seekTime) {
                self.player.currentPlaybackTime = self.seekTime;
                self.seekTime = 0; //置空
                [self.player play];//播放
            }
        }
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0){
        //由于网络等原因，导致了视频暂停，重新添加加载动画
        DebugLog(@"自动暂停,播放状态：%d",(int)loadState);
        //缓冲
        self.state = DFPlayerStateBuffering;
        //缓存好了，达到继续播放状态
        [self.delegate didBuffer:self];
    }else if((loadState & IJKMPMovieLoadStateStalled) != 0){
        DebugLog(@"%d",(int)loadState);
    }else{
        DebugLog(@"%d",(int)loadState);
    }
}
#pragma mark - 视频播放完成或者用户退出
-(void) moviePlayBackFinish:(NSNotification*)notification{
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
            case IJKMPMovieFinishReasonPlaybackEnded:{
                DebugLog(@"播放完成：%d",reason);
                self.state = DFPlayerStateStoped;
                
                if (!self.playerStatusModel.isDragged) {
                    //如果不在拖拽中直接结束
                    self.playerStatusModel.playDidEnd = YES;
                }
                break;
            }
            case IJKMPMovieFinishReasonUserExited:{
                DebugLog(@"用户退出播放：%d",reason);
                break;
            }
            case IJKMPMovieFinishReasonPlaybackError:{
                DebugLog(@"播放出现错误：%d",reason);
                self.state = DFPlayerStateFailed;
                break;
            }
        default:
            DebugLog(@"playbackPlayBackDidFinish: %d",reason);
            break;
    }
}
#pragma mark - 准备开始播放了
-(void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification{
    DebugLog(@"media is prepare to play did change");
}
#pragma mark - 播放状态改变了
-(void) moviePlayBackStateDidChange:(NSNotification*)notification{
    if (self.player.playbackState  == IJKMPMoviePlaybackStatePlaying) {
        //视频开始播放时开启计时器
        if (!self.timer) {
            //更新进度条
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(update) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
    
    switch (_player.playbackState) {
            case IJKMPMoviePlaybackStateStopped:{
                DebugLog(@"播放停止：%d",(int)_player.playbackState);
                // 这里的回调也会来多次(一次播放完成, 会回调三次), 所以, 这里不设置
                _state = DFPlayerStateStoped;
                break;
            }
            case IJKMPMoviePlaybackStatePlaying:{
                DebugLog(@"播放中：%d",(int)_player.playbackState);
                _state = DFPlayerStatePlaying;
                break;
            }
            case IJKMPMoviePlaybackStatePaused:{
                DebugLog(@"播放暂停：%d",(int)_player.playbackState);
                _state = DFPlayerStatePause;
                break;
            }
            case IJKMPMoviePlaybackStateInterrupted:{
                DebugLog(@"播放被打断：%d",(int)_player.playbackState);
                break;
            }
            case IJKMPMoviePlaybackStateSeekingForward:
            case IJKMPMoviePlaybackStateSeekingBackward:{
                DebugLog(@"快进/快退 %d",(int)_player.playbackState);
                break;
            }
        default:
            break;
    }
}

//移除视频播放器状态改变监听
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}

#pragma mark - public method
-(void) play{
    if (self.state == DFPlayerStateReadyToPlay || self.state == DFPlayerStatePause || self.state == DFPlayerStateBuffering) {
        [self.player play];
        self.playerStatusModel.pauseByUser = NO;
        if (self.player.playbackRate > 0) {
            self.state = DFPlayerStatePlaying;
        }
    }
}

-(void) replay{
    self.initReadyToPlay = NO;
    
    [self.player prepareToPlay];
    [self.player play];
    
    self.playerStatusModel.playDidEnd = NO;
}

-(void) pause{
    if (self.state == DFPlayerStatePlaying || self.state == DFPlayerStateBuffering) {
        [self.player pause];
        
        self.playerStatusModel.pauseByUser = YES;
        self.state = DFPlayerStatePause;
    }
}

-(void) stop{
    [self.player setPlaybackRate:0.0];
    [self.player shutdown];
    
    [self removeMovieNotificationObservers];//取消状态监听
    [self removeBackgroundNotificationObservers];
    [self.timer invalidate];
    
    [self.playerLayerView removeFromSuperview];
    _playerLayerView     = nil;
    self.player          = nil;
    self.initReadyToPlay = NO;
}

-(void) seekToTime:(NSInteger)drageSeconds completionHandler:(void (^)())completionHandler{
    [self.player pause]; //暂停
    //是快进不是被用户暂停
    self.playerStatusModel.pauseByUser = NO;
    
    self.player.currentPlaybackTime = drageSeconds;
    //视频跳转回调
    if (completionHandler) {
        completionHandler();
    }
    
    [self.player play];
    
}

/**
 改变音量
 @param value 改变值
 */
-(void) changeVolume:(CGFloat)value{
    self.volumeViewSlider.value -= value/10000;
}

#pragma mark - 系统音量相关

/**
 获取系统音量
 */
-(void) configureVolume{
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            _volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    
    if (!success) {
        //headle error
    }
    
    //监听耳机插拔通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallBack:) name:AVAudioSessionRouteChangeNotification object:nil];
    
}

/**
 耳机插拔事件
 */
-(void) audioRouteChangeListenerCallBack:(NSNotification *)notification{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            //耳机插入
            case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
                
                break;
            }
            //耳机拔掉
            case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
                [self play];
                break;
            }
            case AVAudioSessionRouteChangeReasonCategoryChange:{
                break;
            }
        default:
            break;
    }
}

@end
