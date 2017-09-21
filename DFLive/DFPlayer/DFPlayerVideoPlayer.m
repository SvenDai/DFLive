//
//  DFPlayerVideoPlayer.m
//  DFLive
//
//  Created by daifeng on 2017/9/19.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFPlayerVideoPlayer.h"
#import "DFPlayerManager.h"
#import "DFVideoPlayerView.h"
#import "DFPlayerModel.h"
#import "DFPlayerStatusModel.h"
#import "DFBrightnessView.h"

@interface DFPlayerVideoPlayer ()<DFPlayerManagerDelegate, DFVideoPlayerViewDelegate, DFPlayerControlViewDelegate,DFPortraitControlViewDelegate, DFLandScapeControlViewDelegate, DFCoverControlViewDelegate,DFLoadingViewDelegate>

/**
 代理
 */
@property(nonatomic,weak) id<DFPlayerVideoPlayerDelegate> delegate;

/**
 player最底层的view
 */
@property(nonatomic,strong) DFVideoPlayerView *videoPlayerView;

/**
 player管理
 */
@property(nonatomic,strong) DFPlayerManager *playerMgr;

/**
 player模型
 */
@property(nonatomic,strong) DFPlayerModel *playerModel;

/**
 player状态模型
 */
@property(nonatomic,strong) DFPlayerStatusModel *playerStatusModel;

/**
 用来保存pan手势的总时长
 */
@property(nonatomic,assign) CGFloat sumTime;

/**
 是否被用户暂停
 */
@property(nonatomic,assign) BOOL isPauseByUser;

@end

@implementation DFPlayerVideoPlayer

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - public method
+(instancetype) videoPlayerWithView:(UIView *)view delegate:(id<DFPlayerVideoPlayerDelegate>)delegate playerModel:(DFPlayerModel *)playerModel{
    if (view == nil) {
        return nil;
    }
    
    DFPlayerVideoPlayer *instance = [[DFPlayerVideoPlayer alloc]init];
    instance.delegate = delegate;
    //创建播放器状态模型
    instance.playerStatusModel = [[DFPlayerStatusModel alloc]init];
    [instance.playerStatusModel playerResetStatusModel];
    
    //创建底层视图
    instance.videoPlayerView = [DFVideoPlayerView videoPlayerViewWithSuperView:view delegate:instance playerStatusModel:instance.playerStatusModel];
    
    instance.videoPlayerView.playerControlView.delegate = instance;
    instance.videoPlayerView.playerControlView.portraitControlView.delegate  = instance;
    instance.videoPlayerView.playerControlView.landScapeControlView.delegate = instance;
    instance.videoPlayerView.loadingView.delegate      = instance;
    instance.videoPlayerView.coverControlView.delegate = instance;
    
    //创建avplayer manage
    instance.playerMgr = [DFPlayerManager playerManagerWithDelegate:instance playerStatusModel:instance.playerStatusModel];
    //设置播放器模型
    instance.playerModel = playerModel;

    return instance;
}
//在当前界面播放新视频时调用
-(void) resetToPlayNewVideo:(DFPlayerModel *)playerModel{
    [self resetPlayer];
    self.playerModel = playerModel;
    [self configPlayer];
}

//自动播放
-(void) autoPlayTheVideo{
    [self configPlayer]; //配置
    [self.videoPlayerView.coverControlView removeFromSuperview];//移除封面
    self.videoPlayerView.loadingView.hidden = NO;
}

-(void) playVideo{
    if (self.playerMgr.state == DFPlayerStateStoped) {//状态为stop时点击重新播放
        [self.playerMgr replay];
    }else{
        [self.playerMgr play];
    }
}

-(void) pauseVideo{
    [self.playerMgr pause];
}

-(void) stopVideo{
    [self.playerMgr stop];
}

-(void) destroyVideo{
    [self.playerMgr stop];
}

#pragma mark - private method

/**
 重置播放器
 */
-(void) resetPlayer{
    //设置播放完成
    self.playerStatusModel.playDidEnd         = NO;
    self.playerStatusModel.didEnterBackground = NO;
    self.playerStatusModel.autoPlay           = NO;
    
    if (self.playerMgr) {
        [self.playerMgr stop];
    }
    
    [self.videoPlayerView playerResetVideoPlayerView];
}

/**
 配置播放器
 */
-(void) configPlayer{
    //销毁之前的视频
    if(self.playerMgr){
        [self.playerMgr stop];
    }
    
    [self.videoPlayerView.playerControlView loading];
    [self.playerMgr initPlayerWithUrl:self.playerModel.videoURL];
    [self.videoPlayerView setPlayerLayerView:self.playerMgr.playerLayerView];
    
    self.isPauseByUser = NO;
}


#pragma mark - setter
-(void)setPlayerModel:(DFPlayerModel *)playerModel{
    _playerModel = playerModel;
    //各个界面同步
    
    [self.videoPlayerView.coverControlView syncCoverImageViewWithUrlString:playerModel.placeholderImageURLString placeholderImage:playerModel.placeholderImage];
    
    self.playerMgr.seekTime = self.playerModel.seekTime;
    self.videoPlayerView.playerControlView.viewTime = self.playerModel.viewTime;
    [self.videoPlayerView.playerControlView.landScapeControlView syncTitle:self.playerModel.title];
}

#pragma mark - DFPlayerManagerDelegate
-(void) changePlayerState:(DFPlayerState)state{
    switch (state) {
            case DFPlayerStateReadyToPlay:{
                [self.videoPlayerView.playerControlView readyToPlay];
            }
            break;
            
            case DFPlayerStatePlaying:{
                [self.videoPlayerView.playerControlView.portraitControlView syncPlayPauseButton:YES];
                [self.videoPlayerView.playerControlView.landScapeControlView syncPlayPauseButton:YES];
                self.isPauseByUser = NO;
            }
            break;
            
            case DFPlayerStatePause:{
                [self.videoPlayerView.playerControlView.portraitControlView syncPlayPauseButton:NO];
                [self.videoPlayerView.playerControlView.landScapeControlView syncPlayPauseButton:NO];
                self.isPauseByUser = YES;
            }
            break;
            
            case DFPlayerStateStoped:{
                [self.videoPlayerView playDidEnd];
            }
            break;
            
            case DFPlayerStateBuffering:{
                [self.videoPlayerView.playerControlView loading];
            }
            break;
            
            case DFPlayerStateFailed:{
                [self.videoPlayerView loadFailed];
                self.videoPlayerView.loadingView.hidden = YES;
                
                [DFBrightnessView sharedBrightnessView].isStartPlay = YES;
                [self.videoPlayerView.playerControlView loadFailed];
            }
            break;
            
            case DFPlayerStateUnKnow:{
                
            }
            break;
        default:
            break;
    }
}

-(void) changeLoadProgress:(double)progress sencond:(CGFloat)second{
    [self.videoPlayerView.playerControlView.landScapeControlView syncBufferProgress:progress];
    [self.videoPlayerView.playerControlView.portraitControlView syncBufferProgress:progress];
    
    //如果缓冲完成或者达到两秒以上则开始播放
    if (progress == 1.0 || second >= [self.playerMgr currentTime]+2.5) {
        [self didBuffer:self.playerMgr];
    }
}

-(void) changePlayerProgress:(double)progress second:(CGFloat)second{
    if (self.playerStatusModel.isDragged) {//在拖拽进度条时不应该去更新进度条的值
        return;
    }
    
    [self.videoPlayerView.playerControlView.portraitControlView syncPlayProgress:progress];
    [self.videoPlayerView.playerControlView.landScapeControlView syncPlayProgress:progress];
    
    [self.videoPlayerView.playerControlView.portraitControlView syncPlayTime:second];
    [self.videoPlayerView.playerControlView.landScapeControlView syncPlayTime:second];
    
    [self.videoPlayerView.playerControlView.portraitControlView syncDurationTime:self.playerMgr.duration];
    [self.videoPlayerView.playerControlView.landScapeControlView syncDurationTime:self.playerMgr.duration];
    
}

-(void) didBuffer:(DFPlayerManager *)playerMgr{
    if (self.playerMgr.state == DFPlayerStateBuffering || !self.playerStatusModel.isPauseBuUser) { //在缓冲状态下，且不被用户暂停
        [self.playerMgr play];
    }
}

-(void) playerReadyToPlay{
    [self.videoPlayerView startReadyToPlay];
    self.videoPlayerView.loadingView.hidden = YES;
    
    [DFBrightnessView sharedBrightnessView].isStartPlay = YES;
}
#pragma mark - DFVideoPlayerViewDelegate
-(void) doubleTapAction{
    if (self.playerStatusModel.isPauseBuUser) {
        [self.playerMgr play];
    }else{
        [self.playerMgr pause];
    }
    
    if (!self.playerStatusModel.isAutoPlay) {
        self.playerStatusModel.autoPlay = YES;
        [self configPlayer];
    }
}

-(void) panHorizontalBegainMoved{
    self.sumTime = self.playerMgr.currentTime;
}

-(void) panHorizontalMoving:(CGFloat)value{
    //每次滑动需要叠加的时间
    self.sumTime += value/200;
    
    //需要限定sumTime 的范围
    CGFloat totalMovieDuration = self.playerMgr.duration;
    if (self.sumTime > totalMovieDuration) {
        self.sumTime = totalMovieDuration;
    }
    if (self.sumTime <0 ) {
        self.sumTime = 0;
    }
    
    BOOL style = false;
    if (value > 0) {
        style = YES;
    }
    if (value < 0) {
        style = NO;
    }
    if (value ==0) {
        return;
    }
    
    self.playerStatusModel.dragged = YES;
    
    //改变currentLabel的值
    CGFloat draggedValue = (CGFloat)self.sumTime / (CGFloat)totalMovieDuration;
    
    [self.videoPlayerView.playerControlView.portraitControlView syncPlayProgress:draggedValue];
    [self.videoPlayerView.playerControlView.landScapeControlView syncPlayProgress:draggedValue];
    
    [self.videoPlayerView.playerControlView.portraitControlView syncPlayTime:self.sumTime];
    [self.videoPlayerView.playerControlView.landScapeControlView syncPlayTime:self.sumTime];
    
    //显示快进/退视图
    [self.videoPlayerView.playerControlView showFastView:self.sumTime totalTime:totalMovieDuration isForward:style];
}

-(void) panHorizontalEndMoved{
    //隐藏快进/退按钮
    [self.videoPlayerView.playerControlView hideFastView];
    
    //seek time
    self.playerStatusModel.pauseByUser = NO;
    [self.playerMgr seekToTime:self.sumTime completionHandler:nil];
    self.sumTime = 0;
    self.playerStatusModel.dragged = NO;
}

-(void) volumeValueChange:(CGFloat)value{
    [self.playerMgr changeVolume:value];
}
#pragma mark - DFPlayerControlViewDelegate
-(void) failButtonClick{
    [self configPlayer];
}

-(void) repeateButtonClick{
    [self.playerMgr replay];
    
    [self.videoPlayerView repeatPlay];
    
    self.playerStatusModel.playDidEnd = NO;
}

-(void)jumpPlayButtonClick:(NSInteger)viewTime{
    if (!viewTime) {
        return;
    }
    [self.playerMgr seekToTime:viewTime completionHandler:nil];
}
#pragma mark - DFLandScapeControlViewDelegate
-(void) landScapeBackButtonClick{
    //延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    [self.videoPlayerView shrinkOrFullScreen:NO];
}

-(void)landScapePlayPauseButtonClick:(BOOL)isSelected{
    //
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    if (isSelected) {
        [self.playerMgr pause];
    }else{
        //如果已经播放完点击重新播放
        if (self.playerMgr.state == DFPlayerStateStoped) {
            [self.playerMgr replay];
        }else{
            [self.playerMgr play];
        }
    }
}
#warning barrage to do
-(void) landScapeSendBarrageButtonClick{
    //
    [self.videoPlayerView.playerControlView autoFadeOutControlView];

}
#warning barrage to do
-(void) landScapeOpenOrCloseBarrageButtonClick:(BOOL)isSelected{
    //
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
}

-(void) landScapeProgressSliderBeginDrag{
    self.playerStatusModel.dragged = YES;
    
    [self.videoPlayerView.playerControlView playerCancelAutoFadeOutControlView];
}
//拖动结束，返回拖动的值
-(void) landScapeProgressSliderEndDrag:(CGFloat)value{
    //计算出拖动当前的秒数
    __weak typeof (self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^{
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        //
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

-(void) landScapeExitFullScreenButtonClick{
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    [self.videoPlayerView shrinkOrFullScreen:NO];
}

-(void) landScapeProgressSliderTapAction:(CGFloat)value{
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

#pragma mark - DFPortraitControlViewDelegate
-(void) portraitBackButtonClick{
    if ([self.delegate respondsToSelector:@selector(playerBackButtonClick)]) {
        [self.delegate playerBackButtonClick];
    }
}

-(void) portraitShareButtonClick{
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    if ([self.delegate respondsToSelector:@selector(playerShareButtonClick)]) {
        [self.delegate playerShareButtonClick];
    }
}

-(void) portraitPlayPuaseButtionClick:(BOOL)isSelected{
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    if (isSelected) { //选中暂停
        [self.playerMgr pause];
    }else{
        if (self.playerMgr.state == DFPlayerStateStoped) {//播放完成，重新播放
            [self.playerMgr replay];
        }else{
            [self.playerMgr play];
        }
    }
}

-(void) portraitProgressSliderBeginDrag{
    self.playerStatusModel.dragged = YES;
    [self.videoPlayerView.playerControlView playerCancelAutoFadeOutControlView];
}

-(void) portraitProgressSliderEndDrag:(CGFloat)value{
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

-(void) portraitProgressSliderTapAction:(CGFloat)value{
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        self.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

-(void) portraitFullScreenButtonClick{
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    [self.videoPlayerView shrinkOrFullScreen:YES];
}
#pragma mark - DFLoadingViewDelegate
-(void) loadingViewBackButtonClick{
    if ([self.description respondsToSelector:@selector(playerBackButtonClick)]) {
        [self.delegate playerBackButtonClick];
    }
}

-(void) loadingViewShareButonClick{
    if ([self.delegate respondsToSelector:@selector(playerShareButtonClick)]) {
        [self.delegate playerShareButtonClick];
    }
}

#pragma mark - DFCoverControlViewDelegate
-(void) coverControlViewBackButtonClick{
    if ([self.delegate respondsToSelector:@selector(playerBackButtonClick)]) {
        [self.delegate playerBackButtonClick];
    }
}

-(void)coverControlViewShareButtionClick{
    if ([self.delegate respondsToSelector:@selector(playerShareButtonClick)]) {
        [self.delegate playerShareButtonClick];
    }
}

-(void) coverControlViewBackgroundImageViewTapAction{
    if ([self.delegate respondsToSelector:@selector(controlViewTapAction)]) {
        [self.delegate controlViewTapAction];
    }
}

@end
