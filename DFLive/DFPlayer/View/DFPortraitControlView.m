//
//  DFPortraitControlView.m
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//  竖屏时的控制视图

#import "DFPortraitControlView.h"
#import "UIColor+Hex.h"

@interface DFPortraitControlView ()

/**
 返回按钮
 */
@property(nonatomic,strong) UIButton *backBtn;

/**
 分享按钮
 */
@property(nonatomic,strong) UIButton *shareBtn;

/**
 底部工具栏按钮
 */
@property(nonatomic,strong) UIView   *bottomToolView;

/**
 播放/暂停按钮
 */
@property(nonatomic,strong) UIButton *playOrPauseBtn;

/**
 当前播放时间label
 */
@property(nonatomic,strong) UILabel  *currentTimeLabel;

/**
 滑杆
 */
@property(nonatomic,strong) UISlider *videoSlider;

/**
 进度条
 */
@property(nonatomic,strong) UIProgressView *progressView;

/**
 视频总时长
 */
@property(nonatomic,strong) UILabel  *totelTimeLabel;

/**
 全屏按钮
 */
@property(nonatomic,strong) UIButton *fullScreenBtn;

/**
 视频时长
 */
@property(nonatomic,assign) double   durationTime;

@end

@implementation DFPortraitControlView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加子组件
        [self addSubview:self.backBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.bottomToolView];
        //添加工具栏子组件
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.progressView];
        [self.bottomToolView addSubview:self.videoSlider];
        [self.bottomToolView addSubview:self.totelTimeLabel];
        [self.bottomToolView addSubview:self.fullScreenBtn];
        
        //设置子控件布局
        [self setSubviewContraints];
        //设置子控件的响应事件
        [self setSubviewAction];
        
    }
    return self;
}

#pragma mark - set subview action
-(void) setSubviewAction{
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    //添加滑动手势
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSliderAction:)];
    [self.videoSlider addGestureRecognizer:sliderTap];
    //开始滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchBeganAction:) forControlEvents:UIControlEventTouchDown];
    //滑动中事件
    [self.videoSlider addTarget:self action:@selector(progressSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    //滑动结束事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchEndedAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) backBtnClickAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(portraitBackButtonClick)]) {
        [self.delegate portraitBackButtonClick];
    }
}

-(void) shareBtnClickAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(portraitShareButtonClick)]) {
        [self.delegate portraitShareButtonClick];
    }
}

-(void) playOrPauseBtnClickAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(portraitPlayPuaseButtionClick:)]) {
        [self.delegate portraitPlayPuaseButtionClick:sender.isSelected];
    }
}

-(void) fullScreenBtnClickAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(portraitFullScreenButtonClick)]) {
        [self.delegate portraitFullScreenButtonClick];
    }
}

-(void) tapSliderAction:(UITapGestureRecognizer*) tap{
    if ([tap.view isKindOfClass:[UISlider class]] && [self.delegate respondsToSelector:@selector(portraitProgressSliderTapAction:)]) {
        
        UISlider *slider = (UISlider*)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        //视频快进/快退的值
        CGFloat tapValue = point.x/length;
        
        [self.delegate portraitProgressSliderTapAction:tapValue];
    }
}

-(void) progressSliderTouchBeganAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(portraitProgressSliderBeginDrag)]) {
        [self.delegate portraitProgressSliderBeginDrag];
    }
}

-(void) progressSliderValueChangedAction:(UISlider*)sender{
    //拖拽时修改已经播放的时间(滑杆值（0-1）* 视频总时长)
    [self syncPlayTime:(sender.value * self.durationTime)];
}

-(void) progressSliderTouchEndedAction:(UISlider*)sender{
    if ([self.delegate respondsToSelector:@selector(portraitProgressSliderEndDrag:)]) {
        [self.delegate portraitProgressSliderEndDrag:sender.value];
    }
}

#pragma mark - public method
-(void) playerResetControlView{
    self.backgroundColor = [UIColor clearColor];
    
    self.videoSlider.value     = 0;
    self.progressView.progress = 0;
    
    self.currentTimeLabel.text = @"00:00";
    self.totelTimeLabel.text   = @"00:00";
    
    self.playOrPauseBtn.selected = YES;
    
    self.backBtn.alpha        = 1;
    self.shareBtn.alpha       = 1;
    self.bottomToolView.alpha = 1;
}

-(void) playEndHideView:(BOOL)playEnd{
    self.shareBtn.alpha = playEnd;
    self.backBtn.alpha = playEnd;
    self.bottomToolView.alpha = 0;
}

-(void) syncPlayPauseButton:(BOOL)isPlay{
    if (isPlay) {
        self.playOrPauseBtn.selected = YES;
    }else{
        self.playOrPauseBtn.selected = NO;
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
    NSString *durationTimeString = [self convertTimeSecond:time];
    self.totelTimeLabel.text = durationTimeString;
}

#pragma mark - Other
// !!!: 将秒数时间转换成mm:ss
- (NSString *)convertTimeSecond:(NSInteger)second {
    
    NSInteger durMin = second / 60; // 秒
    NSInteger durSec = second % 60; // 分钟
    NSString *timeString = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    
    return timeString;
}

#pragma mark - add subview contraints
-(void) setSubviewContraints{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(2);
        make.left.equalTo(self.mas_left).offset(5);
        make.width.offset(52);
        make.height.offset(42);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(2);
        make.trailing.equalTo(self.mas_trailing).offset(-5);
        make.width.offset(52);
        make.height.offset(42);
    }];
    
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(39);
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomToolView.mas_leading).offset(10);
        make.centerX.equalTo(self.bottomToolView);
        make.width.height.mas_equalTo(28);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.playOrPauseBtn.mas_trailing).offset(4);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
        make.width.mas_equalTo(48);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(28);
        make.trailing.equalTo(self.bottomToolView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
    }];
    
    [self.totelTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(-4);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
        make.width.mas_equalTo(48);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(9);
        make.trailing.equalTo(self.totelTimeLabel.mas_leading).offset(-9);
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(9);
        make.trailing.equalTo(self.totelTimeLabel.mas_leading).offset(-9);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - getter
#warning - add picture resource
-(UIButton*) backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"dis_live_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

-(UIButton*) shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"dis_live_share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

-(UIView*)bottomToolView{
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc]init];
        _bottomToolView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3f];
    }
    return _bottomToolView;
}

-(UIButton*) playOrPauseBtn{
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"dis_live_play_btn"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"dis_live_pause_btn"] forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

-(UILabel*) currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc]init];
        _currentTimeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

-(UISlider*) videoSlider{
    if (!_videoSlider) {
        _videoSlider =  [[UISlider alloc]init];
        _videoSlider.maximumValue = 1;
        _videoSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"e6420d"];
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        [_videoSlider setThumbImage:[UIImage imageNamed:@"dis_live_slider"] forState:UIControlStateNormal];
    }
    return _videoSlider;
}

-(UIProgressView*)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"efefef"];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"a5a5a5"];
    }
    return _progressView;
}

-(UILabel*) totelTimeLabel{
    if (!_totelTimeLabel) {
        _totelTimeLabel = [[UILabel alloc]init];
        _totelTimeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        _totelTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totelTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totelTimeLabel.text = @"00:00";
    }
    return _totelTimeLabel;
}

-(UIButton*)fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"dis_live_fullscreen"] forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}
    
@end
