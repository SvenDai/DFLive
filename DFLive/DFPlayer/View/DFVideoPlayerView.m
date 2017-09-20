//
//  DFVideoPlayerView.m
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFVideoPlayerView.h"
#import "DFPlayerStatusModel.h"
#import "DFBrightnessView.h"

// 水平和垂直移动方向枚举值
typedef NS_ENUM(NSInteger, PanDirection) {
    PanDirectionHorizontalMoved, //水平
    PanDirectionVerticalMoved    //垂直
};

@interface DFVideoPlayerView ()<UIGestureRecognizerDelegate>
@property(nonatomic,weak) id<DFVideoPlayerViewDelegate> delegate;
@property(nonatomic,weak) UIView *videoView;

@property(nonatomic,weak) UIView *playerLayerView;

@property(nonatomic,strong) DFPlayerControlView *playerControlView;

@property(nonatomic,strong) DFPlayerStatusModel *playerStatusModel;

@property(nonatomic,assign) BOOL isVolume;

@property(nonatomic,assign) PanDirection panDirection;

@property(nonatomic,strong) UITapGestureRecognizer *singleTap;

@property(nonatomic,strong) UITapGestureRecognizer *doubleTap;

@property(nonatomic,strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation DFVideoPlayerView

-(instancetype) init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

+(instancetype) videoPlayerViewWithSuperView:(UIView *)superview delegate:(id<DFVideoPlayerViewDelegate>)delegate playerStatusModel:(DFPlayerStatusModel *)playerStatusModel{
    
    DFVideoPlayerView *instance = [[DFVideoPlayerView alloc]init];
    instance.videoView = superview;
    instance.delegate  = delegate;
    
    instance.playerStatusModel = playerStatusModel;
    //加入父视图
    [instance addToSuperView:superview];
    //设置子视图布局
    [instance setSubviewConstraints];
    
    return instance;
}

#pragma mark - 设置屏幕旋转监听
-(void) listeningRotating{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
#pragma mark - 屏幕监听事件
-(void) onDeviceOrientationDidChange{
    if (![DFBrightnessView sharedBrightnessView].isStartPlay || !_playerControlView) {
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) {
        return;
    }
    if (UIDeviceOrientationIsLandscape(orientation)) {
        [self setOrientationLandscapeConstraint]; //横屏
    }else{
        [self setOrientationPortraitConstraint]; //竖屏
    }
    [self layoutIfNeeded];
}
//设置横屏
-(void) setOrientationLandscapeConstraint{
    //非全屏切换为全屏
    if (!self.playerStatusModel.isFullScreen) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
    self.playerStatusModel.fullScreen = YES;
    //播放结束
    if (self.playerStatusModel.playDidEnd && _playerControlView) {
        [self.playerControlView playEndHideControlView];
        return;
    }
    //如果正在显示控制栏，屏幕切换时就显示
    if(self.playerControlView.showing){
        [self.playerControlView setIsShowing:NO];
        //显示控制层
        [self.playerControlView showControl];
    }
}

//设置竖屏
-(void) setOrientationPortraitConstraint{
    self.playerStatusModel.fullScreen = NO;
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    if (self.playerStatusModel.playDidEnd) {
        [self.playerControlView playEndHideControlView];
    }
    //如果正在显示控制栏，屏幕切换时就显示
    if (self.playerControlView.isShowing) {
        [self.playerControlView setIsShowing:NO];
        //显示控制层
        [self.playerControlView showControl];
    }
}
//强制屏幕旋转
-(void) interfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        //从2开始是因为0、1两个参数被selector和target占用
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        
    }
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - gestureRecognizer
-(void) createGesture{
    if (self.singleTap || self.doubleTap || self.panRecognizer) {
        [self removeGestureRecognizer:self.singleTap];
        [self removeGestureRecognizer:self.doubleTap];
        [self removeGestureRecognizer:self.panRecognizer];
    }
    //单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1;
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];

    //双击
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1;
    self.doubleTap.numberOfTapsRequired    = 2;
    [self addGestureRecognizer:self.doubleTap];
    
    //?? 解决点击当前view时响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    
    //双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    
    //添加手势，用来控制音量、亮度、快进、快退
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    self.panRecognizer.delegate = self;
    
    [self.panRecognizer setMaximumNumberOfTouches:1];
    [self.panRecognizer setDelaysTouchesBegan:YES];
    [self.panRecognizer setDelaysTouchesEnded:YES];
    [self.panRecognizer setCancelsTouchesInView:YES];
    
    [self addGestureRecognizer:self.panRecognizer];
    
}

/**
 单击 显示/隐藏控制层
 @param tap 手势
 */
-(void) singleTapAction:(UITapGestureRecognizer*)tap{
    if (self.playerStatusModel.playDidEnd) {
        return;
    }
    if (self.playerControlView.isShowing) {
        [self.playerControlView hideControl];
    }else{
        [self.playerControlView showControl];
    }
}

/**
 双击 播放/暂停
 @param tap 手势
 */
-(void) doubleTapAction:(UIGestureRecognizer*)tap{
    if(self.playerStatusModel.playDidEnd){return;}
    
    //显示控制层
    [self.playerControlView setIsShowing:NO];
    [self.playerControlView showControl];
    
    if ([self.delegate respondsToSelector:@selector(doubleTapAction)]) {
        [self.delegate doubleTapAction];
    }
}

/**
 pan手势事件,(左上下调节亮度、右上下调节音量、水平快进快退）
 @param pan 手势
 */
-(void) panDirection:(UIPanGestureRecognizer*)pan{
    //根据view 上pan的位置确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    //要响应水平和垂直移动
    //根据上次和本次的移动位置，算出速率的point
    CGPoint veloctiPoint = [pan velocityInView:self];
    
    //判断是垂直移动还是水平移动
    switch (pan.state) {
            case UIGestureRecognizerStateBegan:{//开始移动
                //使用绝对值来判断移动方向
                CGFloat x = fabs(veloctiPoint.x);
                CGFloat y = fabs(veloctiPoint.y);
                if (x > y) { //水平
                    self.panDirection = PanDirectionHorizontalMoved;
                    if ([self.delegate respondsToSelector:@selector(panHorizontalBegainMoved)]) {
                        [self.delegate panHorizontalBegainMoved];
                    }
                }else if(x < y){
                    self.panDirection = PanDirectionVerticalMoved;
                    //滑动开始时调整为正在控制音量/亮度
                    if (locationPoint.x > self.bounds.size.width / 2) {//右边调节音量
                        self.isVolume = YES;
                    }else{ //左边调节亮度
                        self.isVolume = NO;
                    }
                }
                break;
            }
            case UIGestureRecognizerStateChanged:{//正在移动
                switch (self.panDirection) {
                        case PanDirectionVerticalMoved:{
                            if ([self.delegate respondsToSelector:@selector(panHorizontalMoving:)]) {
                                [self.delegate panHorizontalMoving:veloctiPoint.x];
                            }
                            break;
                        }
                        case PanDirectionHorizontalMoved:{
                            [self verticalMoved:veloctiPoint.y]; //垂直方向只要y方向的值
                            break;
                        }
                        
                    default:
                        break;
                }
                break;
            }
            case UIGestureRecognizerStateEnded:{//结束移动
                // 移动结束也需要判断垂直或者平移
                // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
                switch (self.panDirection) {
                        case PanDirectionHorizontalMoved:{
                            if ([self.delegate respondsToSelector:@selector(panHorizontalEndMoved)]) {
                                [self.delegate panHorizontalEndMoved];
                            }
                            break;
                        }
                        case PanDirectionVerticalMoved:{
                            //垂直移动结束后，把状态改变
                            self.isVolume = NO;
                            break;
                        }
                    default:
                        break;
                }
                break;
            }
            
        default:
            break;
    }
}

-(void) verticalMoved:(CGFloat)value{
    if (self.isVolume) {
        if ([self.delegate respondsToSelector:@selector(volumeValueChange:)]) {
            [self.delegate volumeValueChange:value];
        }else{
            ([UIScreen mainScreen].brightness -= value / 10000);
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.playerStatusModel.playDidEnd) {
            return NO;
        }
    }
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    return YES;
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.playerStatusModel.isAutoPlay) {
        UITouch *touch = [touches anyObject];
        if (touch.tapCount == 1) {
            [self performSelector:@selector(singleTapAction:) withObject:nil];
        }else if(touch.tapCount == 2){
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction:) object:nil];
            [self doubleTapAction:touch.gestureRecognizers.lastObject];
        }
    }
}

#pragma mark - public method
//设置播放器的容器层
-(void) setPlayerLayerView:(UIView *)playerLayerView{
    _playerLayerView = playerLayerView;
    [self insertSubview:playerLayerView atIndex:0];
    
    [playerLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.trailing.mas_equalTo(self);
    }];
}
//重置
-(void) playerResetVideoPlayerView{
    [self.playerControlView playerResetControlView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//设置全屏
-(void) shrinkOrFullScreen:(BOOL)isFull{
    if (isFull) {//
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight]; //右向横屏
        [self setOrientationLandscapeConstraint];
    }else{
        [self interfaceOrientation:UIInterfaceOrientationPortrait]; //竖屏
        [self setOrientationPortraitConstraint];
    }
}
//开始准备播放
-(void) startReadyToPlay{
    //设置控制层
    [self ui];
    //添加手势
    if(!self.singleTap || !self.doubleTap || !self.panRecognizer){
        [self createGesture];
    }
    //设置viewTime view 显示控制层
    [self.playerControlView startReadyToPlay];
    //监听屏幕旋转
    [self listeningRotating];
}
//播放结束
-(void) playDidEnd{
    [self.playerControlView playDidEnd];
}
//重播
-(void) repeatPlay{
    [self.playerControlView playerResetControlView];
    [self.playerControlView showControl];
}

//加载失败
-(void) loadFailed{
    //设置子控制层
    [self ui];
    //监听屏幕旋转
    [self listeningRotating];
}

#pragma mark - private method
//设置子视图约束
-(void) setSubviewConstraints{
    [self addSubview:self.loadingView];
    [self addSubview:self.coverControlView];
    
    [self.coverControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(self);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(self);
    }];
}
//将此view放到父视图中
-(void) addToSuperView:(UIView*)superView{
    if ([self superview] == superView) {
        return;
    }
    if ([self superview]) {
        [self removeFromSuperview];
    }
    
    [self.superview addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.mas_equalTo(superView);
    }];
}

-(void) ui{
    if (_playerControlView && _playerControlView.superview) {
        return;
    }
    // 控制层、互动层
    [self insertSubview:self.playerControlView aboveSubview:self.playerLayerView];
    [self.playerControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
}

#pragma mark - getter
-(DFPlayerControlView*) playerControlView{
    if (!_playerControlView) {
        _playerControlView = [DFPlayerControlView playerControlViewWithStatusModel:self.playerStatusModel];
    }
    return _playerControlView;
}

-(DFCoverControlView*) coverControlView{
    if (!_coverControlView) {
        _coverControlView = [[DFCoverControlView alloc]init];
    }
    return _coverControlView;
}

-(DFLoadingView*) loadingView{
    if (!_loadingView) {
        _loadingView = [[DFLoadingView alloc]init];
    }
    return _loadingView;
}
@end
