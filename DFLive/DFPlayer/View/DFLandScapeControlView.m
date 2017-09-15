//
//  DFLandScapeControlView.m
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFLandScapeControlView.h"
#import "UIColor+Hex.h"

@interface DFLandScapeControlView ()

/**
 顶部工具栏
 */
@property(nonatomic,strong) UIView *topToolView;
/**
 返回按钮
 */
@property(nonatomic,strong) UIButton *backBtn;

/**
 标题栏
 */
@property(nonatomic,strong) UILabel *titleLabel;

/**
 播放/暂停大按钮
 */
@property(nonatomic,strong) UIButton *playOrPauseBigBtn;

/**
 底部工具栏
 */
@property(nonatomic,strong) UIView * bottomToolView;

/**
 播放/暂停小按钮
 */
@property(nonatomic,strong) UIButton *playOrPauseSmallBtn;

/**
 发送弹幕按钮
 */
@property(nonatomic,strong) UIButton *sendBarrageBtn;

/**
 弹幕开关按钮
 */
@property(nonatomic,strong) UIButton *openOrCloseBarrageBtn;

/**
 当前时间
 */
@property(nonatomic,strong) UILabel *currentTimeLabel;

/**
 滑杆
 */
@property(nonatomic,strong) UISlider *videoSlider;

/**
 进度条
 */
@property(nonatomic,strong) UIProgressView * progressView;

/**
 总时间
 */
@property(nonatomic,strong) UILabel *totalTimeLabel;

/** 
 退出全屏按钮
 */
@property(nonatomic,strong) UIButton *exitFullScreenBtn;

/**
 状态栏背景
 */
@property(nonatomic,strong) UIView *statusBackgroundView;

/**
 时长
 */
@property(nonatomic,assign) double durationTime;

@end

@implementation DFLandScapeControlView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加头部子组件
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.titleLabel];
        //添加底部子组件
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseSmallBtn];
        [self.bottomToolView addSubview:self.sendBarrageBtn];
        [self.bottomToolView addSubview:self.openOrCloseBarrageBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.progressView];
        [self.bottomToolView addSubview:self.videoSlider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.exitFullScreenBtn];
        //状态栏
        [self addSubview:self.statusBackgroundView];
        //
        [self addSubview:self.playOrPauseBigBtn];
        //设置子组件布局
        [self setSubviewContraints];
        //设置子组件响应事件
        [self setSubviewAction];
    }
    return self;
}

#pragma mark - public method 
-(void) playerResetControlView{
    self.backgroundColor = [UIColor clearColor];
    
    self.videoSlider.value = 0;
    self.progressView.progress = 0;
    
    self.currentTimeLabel.text = @"00:00";
    self.titleLabel.text       = @"00:00";
    
    self.playOrPauseBigBtn.selected   = YES;
    self.playOrPauseSmallBtn.selected = YES;
    self.sendBarrageBtn.selected      = NO;
    
    self.titleLabel.text = @"";
    
    self.topToolView.alpha          = 1;
    self.bottomToolView.alpha       = 1;
    self.statusBackgroundView.alpha = 1;
    
}

-(void) playerEndHideView:(BOOL)playEnd{
    self.topToolView.alpha          = playEnd;
    self.bottomToolView.alpha       = playEnd;
    
    self.statusBackgroundView.alpha = 0;
    self.playOrPauseBigBtn.alpha    = 0;
}

-(void) syncTitle:(NSString *)title{
    self.titleLabel.text = title;
}

-(void) syncPlayPauseButton:(BOOL)isPlay{
    if (isPlay) {
        self.playOrPauseBigBtn.selected   = YES;
        self.playOrPauseSmallBtn.selected = YES;
    }else{
        self.playOrPauseBigBtn.selected   = NO;
        self.playOrPauseSmallBtn.selected = NO;
    }
}

-(void) syncOpenCloseBarrageButton:(BOOL)isOpen{
    if (isOpen) {
        self.sendBarrageBtn.selected = YES;
    }else{
        self.sendBarrageBtn.selected = NO;
    }
}

-(void) syncBufferProgress:(double)progress{
    self.progressView.progress = progress;
}

-(void) syncPlayProgress:(double)progress{
    self.videoSlider.value = progress;
}

-(void) syncPlayTime:(NSInteger)time{
    if (time < 0) {
        return;
    }
    NSString *progressTimeString = [self convertTimeSecond:time];
    self.currentTimeLabel.text = progressTimeString;
}

-(void) syncDurationTime:(NSInteger)time{
    if (time < 0) {
        return;
    }
    self.durationTime = time;
    self.totalTimeLabel.text = [self convertTimeSecond:time];
}

#pragma mark - Other
// !!!: 将秒数时间转换成mm:ss
- (NSString *)convertTimeSecond:(NSInteger)second {
    
    NSInteger durMin = second / 60; // 秒
    NSInteger durSec = second % 60; // 分钟
    NSString *timeString = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    
    return timeString;
}

#pragma mark - set subview action
-(void) setSubviewAction{
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBigBtn addTarget:self action:@selector(playOrPauseBigBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseSmallBtn addTarget:self action:@selector(playOrPauseSmallBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBarrageBtn addTarget:self action:@selector(sendBarrageBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.openOrCloseBarrageBtn addTarget:self action:@selector(openOrCloseBarrageBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.exitFullScreenBtn addTarget:self action:@selector(exitFullScreenBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加滑杆手势
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSliderAction:)];
    [self.videoSlider addGestureRecognizer:sliderTap];
    
    //开始滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchBeganAction:) forControlEvents:UIControlEventTouchDown];
    //滑动中事件
    [self.videoSlider addTarget:self action:@selector(progressSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    //滑动中事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchEndedAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
}

-(void) backBtnClickAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(landScapeBackButtonClick)]) {
        [self.delegate landScapeBackButtonClick];
    }
}

-(void) playOrPauseBigBtnClickAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(landScapePlayPauseButtonClick:)]) {
        [self.delegate landScapePlayPauseButtonClick:sender.selected];
    }
}

-(void) playOrPauseSmallBtnClickAction:(UIButton*)sender{
    [self playOrPauseBigBtnClickAction:sender];
}

-(void) sendBarrageBtnClickAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(landScapeSendBarrageButtonClick)]) {
        [self.delegate landScapeSendBarrageButtonClick];
    }
}

-(void) openOrCloseBarrageBtnClickAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(landScapeOpenOrCloseBarrageButtonClick:)]) {
        [self.delegate landScapeOpenOrCloseBarrageButtonClick:sender.selected];
    }
}

-(void) exitFullScreenBtnClickAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(landScapeExitFullScreenButtonClick)]) {
        [self.delegate landScapeExitFullScreenButtonClick];
    }
}

-(void) tapSliderAction:(UITapGestureRecognizer*)tap{
    if ([tap.view isKindOfClass:[UISlider class]] && [self.delegate respondsToSelector:@selector(landScapeProgressSliderTapAction:)]) {
        UISlider *slider = (UISlider*)tap.view;
        
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        //快进的进度
        CGFloat tapValue = point.x/length;
        
        [self.delegate landScapeProgressSliderTapAction:tapValue];
    }
}

-(void) progressSliderTouchBeganAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(landScapeProgressSliderBeginDrag)]) {
        [self.delegate landScapeProgressSliderBeginDrag];
    }
}

-(void) progressSliderValueChangedAction:(UISlider*)sender{
    //拖拽时修改播放时间(进度条值（0-1）* 总时长)
    [self syncPlayTime:(sender.value * self.durationTime)];
}

-(void) progressSliderTouchEndedAction:(UISlider*)sender{
    if ([self.delegate respondsToSelector:@selector(landScapeProgressSliderEndDrag:)]) {
        [self.delegate landScapeProgressSliderEndDrag:sender.value];
    }
}



#pragma mark - add subview contraints
-(void) setSubviewContraints{
    [self.topToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(20);
        make.height.mas_equalTo(38);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.centerY.equalTo(self.topToolView.mas_centerY);
        make.width.offset(36);
        make.height.offset(34);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.left.equalTo(self.backBtn.mas_right).offset(5);
    }];
    
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(38);
    }];
    
    [self.playOrPauseSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomToolView.mas_leading).offset(10);
        make.centerY.equalTo(self.bottomToolView.mas_centerY);
        make.width.height.mas_equalTo(28);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.playOrPauseSmallBtn.mas_leading).offset(4);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY);
        make.width.mas_equalTo(48);
    }];
    
    [self.exitFullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bottomToolView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY);
        make.width.height.mas_equalTo(32.5);
    }];
    
    [self.sendBarrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.exitFullScreenBtn.mas_leading).offset(-10);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY);
        make.width.height.mas_equalTo(32.5);
    }];
    
    [self.openOrCloseBarrageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.openOrCloseBarrageBtn.mas_leading).offset(-4);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY);
        make.width.height.mas_equalTo(32.5);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.openOrCloseBarrageBtn.mas_leading).offset(-4);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY);
        make.width.height.mas_equalTo(32.5);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(9);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-9);
        make.centerY.equalTo(self.playOrPauseSmallBtn.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(9);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-9);
        make.height.mas_equalTo(30);
    }];
    
    [self.playOrPauseBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(-10);
        make.bottom.equalTo(self.bottomToolView.mas_top).offset(-10);
        make.width.height.mas_equalTo(75);
    }];
    
    [self.statusBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(20);
    }];
}
#pragma mark - getter
#warning - add picture res
-(UIView*) topToolView{
    if (!_topToolView) {
        _topToolView = [[UIView alloc]init];
        _topToolView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _topToolView;
}

-(UIButton*) backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"dis_live_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

-(UILabel*) titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titleLabel;
}

-(UIButton*) playOrPauseBigBtn{
    if (!_playOrPauseBigBtn) {
        _playOrPauseBigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBigBtn setImage:[UIImage imageNamed:@"dis_live_play"] forState:UIControlStateNormal];
        [_playOrPauseBigBtn setImage:[UIImage imageNamed:@"dis_live_pause"] forState:UIControlStateSelected];
    }
    return _playOrPauseBigBtn;
}

-(UIView*) bottomToolView{
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc]init];
        _bottomToolView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _bottomToolView;
}

-(UIButton*) playOrPauseSmallBtn{
    if (!_playOrPauseSmallBtn) {
        _playOrPauseSmallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseSmallBtn setImage:[UIImage imageNamed:@"dis_live_play_s"] forState:UIControlStateNormal];
        [_playOrPauseSmallBtn setImage:[UIImage imageNamed:@"dis_live_pause_s"] forState:UIControlStateSelected];
    }
    return _playOrPauseSmallBtn;
}

-(UIButton*) sendBarrageBtn{
    if (!_sendBarrageBtn) {
        _sendBarrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBarrageBtn setImage:[UIImage imageNamed:@"dis_live_barrage"] forState:UIControlStateNormal];
    }
    return _sendBarrageBtn;
}

-(UIButton*) openOrCloseBarrageBtn{
    if (!_openOrCloseBarrageBtn) {
        _openOrCloseBarrageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openOrCloseBarrageBtn setImage:[UIImage imageNamed:@"dis_live_barrage_open"] forState:UIControlStateNormal];
        [_openOrCloseBarrageBtn setImage:[UIImage imageNamed:@"dis_live_barrage_close"] forState:UIControlStateSelected];
    }
    return _openOrCloseBarrageBtn;
}

-(UILabel*) currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc]init];
        _currentTimeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

-(UISlider*) videoSlider{
    if (!_videoSlider) {
        _videoSlider = [[UISlider alloc]init];
        _videoSlider.maximumValue = 1;
        _videoSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"e6420d"];
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        [_videoSlider setThumbImage:[UIImage imageNamed:@"dis_live_slider"] forState:UIControlStateNormal];
    }
    return _videoSlider;
}

-(UIProgressView*) progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"efefef"];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"a5a5a5"];
    }
    return _progressView;
}

-(UILabel*) totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

-(UIButton*) exitFullScreenBtn{
    if (!_exitFullScreenBtn) {
        _exitFullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitFullScreenBtn setImage:[UIImage imageNamed:@"dis_live_exitfull"] forState:UIControlStateNormal];
        [_exitFullScreenBtn setImage:[UIImage imageNamed:@"dis_live_exitfull_h"] forState:UIControlStateHighlighted];
    }
    return _exitFullScreenBtn;
}

-(UIView*) statusBackgroundView{
    if (!_statusBackgroundView) {
        _statusBackgroundView = [[UIView alloc]init];
        _statusBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _statusBackgroundView;
}
@end
