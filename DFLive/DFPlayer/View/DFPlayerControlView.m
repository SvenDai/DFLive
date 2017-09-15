//
//  DFPlayerControlView.m
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFPlayerControlView.h"
#import "MMMaterialDesignSpinner.h"
#import "DFPlayerStatusModel.h"
#import "UIColor+Hex.h"

static const CGFloat DFPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat DFPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface DFPlayerControlView ()

/**
 加载loading
 */
@property(nonatomic,strong) MMMaterialDesignSpinner *activity;
/**
 快进视图
 */
@property(nonatomic,strong) UIView                  *fastView;
/**
 快进/退进度
 */
@property(nonatomic,strong) UIProgressView          *fastProgressView;
/**
 快进/退时间
 */
@property(nonatomic,strong) UILabel                 *fastTimeLabel;
/**
 快进/退图片
 */
@property(nonatomic,strong) UIImageView             *fastImageView;
/**
 加载失败按钮
 */
@property(nonatomic,strong) UIButton                *failBtn;
/**
 重播按钮
 */
@property(nonatomic,strong) UIButton                *repeatBtn;
/**
 观看视图视图
 */
@property(nonatomic,strong) UIView                  *watchRecordView;
/**
 关闭观看记录视图
 */
@property(nonatomic,strong) UIButton                *closeWatchRecordBtn;
/**
 观看记录label
 */
@property(nonatomic,strong) UILabel                 *watchRecordLabel;
/**
 跳转播放按钮
 */
@property(nonatomic,strong) UIButton                *jumpPlayBtn;
/**
 是否显示控制层
 */
@property(nonatomic,assign,getter=isShowing) BOOL showing;
/**
 是否播放结束
 */
@property(nonatomic,assign,getter=isPlayEnd) BOOL playEnd;
/**
 播放器参数模型
 */
@property(nonatomic,strong) DFPlayerStatusModel *playerStatusModel;

@end

@implementation DFPlayerControlView

-(instancetype)init{
    self = [super init];
    if (self) {
        //添加所有子控件
        [self addAllSubview];
        //设置控件的布局
        [self setSubviewContraints];
        //添加控件事件
        [self setSubviewAction];
        //隐藏横屏控制视图
        self.landScapeControlView.hidden = YES;
        //初始化时重置controlview
        [self playerResetControlView];
    }
    return self;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    [self layoutIfNeeded];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //取消所有延迟执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void) addAllSubview{
    //横/竖屏 视图
    [self addSubview: self.portraitControlView];
    [self addSubview:self.landScapeControlView];
    //按钮
    [self addSubview:self.activity];
    [self addSubview:self.repeatBtn];
    [self addSubview:self.failBtn];
    //快进视图
    [self addSubview:self.fastView];
    [self.fastView addSubview:self.fastImageView];
    [self.fastView addSubview:self.fastTimeLabel];
    [self.fastView addSubview:self.fastProgressView];
    //观看记录视图
    [self addSubview: self.watchRecordView];
    [self.watchRecordView addSubview:self.closeWatchRecordBtn];
    [self.watchRecordView addSubview:self.watchRecordLabel];
    [self.watchRecordView addSubview:self.jumpPlayBtn];
}

#pragma mark - set subview action 
-(void) setSubviewAction{
    [self.failBtn addTarget:self action:@selector(failBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.repeatBtn addTarget:self action:@selector(repeatBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeWatchRecordBtn addTarget:self action:@selector(closeWatchRecordBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.jumpPlayBtn addTarget:self action:@selector(jumpPlayBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) failBtnClickAction:(UIButton*)sender{
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(failButtonClick)]) {
        [self.delegate failButtonClick];
    }
}

-(void) repeatBtnClickAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(repeateButtonClick)]) {
        [self.delegate repeateButtonClick];
    }
}

-(void) closeWatchRecordBtnClickAction:(UIButton*)sender{
    [self hideWatchRecordView];
}

-(void) jumpPlayBtnClickAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(jumpPlayButtonClick:)]) {
        [self.delegate jumpPlayButtonClick:self.viewTime];
    }
    [self hideWatchRecordView];
}

#pragma mark - public method
+(instancetype) playerControlViewWithStatusModel:(DFPlayerStatusModel *)playerStatusModel{
    DFPlayerControlView *instance = [[self alloc] init];
    instance.playerStatusModel = playerStatusModel;
    return instance;
}

//初始化时重置controlView
-(void) playerResetControlView{
    self.backgroundColor = [UIColor clearColor];
    
    [self.portraitControlView playerResetControlView];
    [self.landScapeControlView playerResetControlView];
    
    self.fastView.hidden  = YES;
    self.repeatBtn.hidden = YES;
    self.failBtn.hidden   = YES;
    
    self.watchRecordView.hidden = YES;
    
    self.showing = NO;
    self.playEnd = NO;
    
    self.viewTime = 0;
    
}
//播放完成隐藏控制层
-(void) playEndHideControlView{
    if (self.playerStatusModel.isFullScreen) {
        self.portraitControlView.hidden  = YES;
        self.landScapeControlView.hidden = NO;
    
        [self.landScapeControlView playerEndHideView:self.playEnd];
    }else{
        self.portraitControlView.hidden  = NO;
        self.landScapeControlView.hidden = YES;
        
        [self.portraitControlView playEndHideView:self.playEnd];
    }
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

//显示状态栏
-(void) showStatusBar{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

//强制设置是否显示了控制层
-(void) setIsShowing:(BOOL)showing{
    self.isShowing = showing;
}

//开始准备播放
-(void) startReadyToPlay{
    if (self.viewTime) {
        [self showWatchRecordView:self.viewTime];
    }
    
    [self showControl];
}
//准备播放隐藏 loading
-(void) readyToPlay{
    [self.activity stopAnimating];
    self.failBtn.hidden = YES;
}
//加载失败 显示失败按钮
-(void) loadFailed{
    [self.activity stopAnimating];
    self.failBtn.hidden = NO;
}
//开始loading
-(void) loading{
    [self.activity startAnimating];
    self.failBtn.hidden  = YES;
    self.fastView.hidden = YES;
    
    self.playEnd = NO;
}
//播放结束显示 重播按钮
-(void) playDidEnd{
    self.backgroundColor = [UIColor colorWithHexString:@"000000"];
    
    [self.activity stopAnimating];
    
    self.failBtn.hidden  = YES;
    self.repeatBtn.hidden = NO;
    
    self.playEnd = YES;
    self.showing = NO;
    //隐藏cotrolview
    [self playEndHideControlView];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
//显示控制层
-(void) showControl{
    if (self.isShowing) {
        [self hideControl];
        return;
    }
    [self playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:DFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
    }];
}
//隐藏控制层
-(void) hideControl{
    if (!self.isShowing) {
        return;
    }
    [self playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:DFPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    } completion:^(BOOL finished) {
        self.showing = NO;
    }];
    
}
//自动延时隐藏控制层
-(void) autoFadeOutControlView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControl) object:nil];
    [self performSelector:@selector(hideControl) withObject:nil afterDelay:DFPlayerAnimationTimeInterval];
}
//取消延时隐藏controlView的方法
-(void) playerCancelAutoFadeOutControlView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControl) object:nil];
}

//显示观看视图
-(void) showWatchRecordView:(NSInteger)viewTime{
    NSInteger proMin = viewTime / 60; //秒
    NSInteger proSec = viewTime % 60; //分
    
    self.watchRecordLabel.text  = [NSString stringWithFormat:@"上次观看至 %02zd:%02zd",proMin,proSec];
    self.watchRecordView.hidden = NO;
    //先取消上次的延迟执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWatchRecordView) object:nil];
    //5s后隐藏观看记录视图
    [self performSelector:@selector(hideWatchRecordView) withObject:nil afterDelay:5.0];
}
//隐藏观看记录视图
-(void) hideWatchRecordView{
    self.watchRecordView.hidden = YES;
    self.viewTime = 0;
}
//显示快进视图
-(void)showFastView:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forward{
    [self.activity stopAnimating];
    
    //拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分
    
    //总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd",proMin,proSec];
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd",durMin,durSec];
    
    CGFloat draggedValue = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr    = [NSString stringWithFormat:@"%@ / %@",currentTimeStr,totalTimeStr];
    //
    if (forward) {
        self.fastImageView.image = [UIImage imageNamed:@"dis_live_forward"];
    }else{
        self.fastImageView.image = [UIImage imageNamed:@"dis_live_forward"];
    }
    
    self.fastView.hidden           = NO;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;
}
//隐藏快进视图
-(void)hideFastView{
    self.fastView.hidden = YES;
}


#pragma mark - private method
//隐藏控制层视图
-(void) hideControlView{
    self.landScapeControlView.hidden = YES;
    self.portraitControlView.hidden  = YES;
    
    if (self.playerStatusModel.isFullScreen && !self.playEnd) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}
//显示控制层视图
-(void) showControlView{
    if (self.playerStatusModel.isFullScreen) {
        self.landScapeControlView.hidden = NO;
        self.portraitControlView.hidden  = YES;
    }else{
        self.portraitControlView.hidden  = NO;
        self.landScapeControlView.hidden = YES;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

//切换分辨率时 重置控制层
-(void) playerResetControlViewForResolution{
    #pragma mark  - todo
}


#pragma mark - set subview contraints
-(void) setSubviewContraints{
    [self.portraitControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(self);
    }];
    
    [self.landScapeControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(self);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(45);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(33);
    }];
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
    }];
    
    [self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.fastView.mas_centerX);
    }];
    
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
    }];
    
    [self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
    }];
    
    [self.watchRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self.watchRecordLabel.mas_right).offset(80);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-50);
    }];
    
    [self.closeWatchRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.top.with.left.mas_equalTo(self.watchRecordView);
    }];
    
    [self.watchRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.closeWatchRecordBtn.mas_right);
        make.top.height.mas_equalTo(self.watchRecordView);
    }];
    
    [self.jumpPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.watchRecordLabel.mas_trailing).offset(3);
        make.trailing.top.mas_equalTo(self.watchRecordView);
    }];
}

#pragma mark - getter
-(DFPortraitControlView*) portraitControlView{
    if (!_portraitControlView) {
        _portraitControlView = [[DFPortraitControlView alloc]init];
    }
    return _portraitControlView;
}

-(DFLandScapeControlView*) landScapeControlView{
    if (!_landScapeControlView) {
        _landScapeControlView = [[DFLandScapeControlView alloc]init];
    }
    return _landScapeControlView;
}

-(MMMaterialDesignSpinner*) activity{
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    }
    return _activity;
}

-(UIView*) fastView{
    if (!_fastView) {
        _fastView = [[UIView alloc] init];
        _fastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
    }
    return _fastView;
}

-(UIProgressView*)fastProgressView{
    if (!_fastProgressView) {
        _fastProgressView = [[UIProgressView alloc]init];
        
        _fastProgressView.tintColor      = [UIColor whiteColor];
        _fastProgressView.trackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}

-(UILabel*) fastTimeLabel{
    if (!_fastTimeLabel) {
        _fastTimeLabel = [[UILabel alloc]init];
        
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

-(UIImageView*)fastImageView{
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc]init];
    }
    return _fastImageView;
}

-(UIButton*) failBtn{
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _failBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
    }
    return _failBtn;
}

-(UIButton*) repeatBtn{
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:[UIImage imageNamed:@"dis_live_repeat"] forState:UIControlStateNormal];
    }
    return _repeatBtn;
}

-(UIView *)watchRecordView{
    if (!_watchRecordView) {
        _watchRecordView = [[UIView alloc] init];
        _watchRecordView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.8];
        
        _watchRecordView.layer.cornerRadius  = 2;
        _watchRecordView.layer.masksToBounds = YES;
    }
    return _watchRecordView;
}

-(UIButton*)closeWatchRecordBtn{
    if (!_closeWatchRecordBtn) {
        _closeWatchRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeWatchRecordBtn setImage:[UIImage imageNamed:@"dis_live_close"] forState:UIControlStateNormal];
    }
    return _closeWatchRecordBtn;
}

-(UILabel*) watchRecordLabel{
    if (!_watchRecordLabel) {
        _watchRecordLabel = [[UILabel alloc] init];
        _watchRecordLabel.text = @"上次观看至00:00";
        _watchRecordLabel.textColor = [UIColor whiteColor];
        _watchRecordLabel.textAlignment = NSTextAlignmentCenter;
        _watchRecordLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _watchRecordLabel;
}

-(UIButton*)jumpPlayBtn{
    if (!_jumpPlayBtn) {
        _jumpPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jumpPlayBtn setTitle:@"跳转播放" forState:UIControlStateNormal];
        [_jumpPlayBtn setTitleColor:[UIColor colorWithHexString:@"ed341c"] forState:UIControlStateNormal];
        _jumpPlayBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _jumpPlayBtn;
}
@end
