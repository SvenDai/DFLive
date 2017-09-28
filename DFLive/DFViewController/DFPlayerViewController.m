//
//  DFPlayerViewController.m
//  DFLive
//
//  Created by daifeng on 2017/9/8.
//  Copyright © 2017年 daifeng. All rights reserved.
//

#import "DFPlayerViewController.h"
#import "DFPlayer.h"
//#import "IJKMediaFramework/IJKMediaFramework.h"

@interface DFPlayerViewController ()<DFPlayerVideoPlayerDelegate>

//@property(nonatomic,strong) IJKFFMoviePlayerController *player;
@property(nonatomic,strong) UIView *playerFatherView;

@property(nonatomic,strong) UIView *topView;

@property(nonatomic,strong) DFPlayerVideoPlayer *player;

@property(nonatomic,strong) DFPlayerModel *playerModel;

@property(nonatomic,assign) BOOL isPlaying;
@property(nonatomic,assign) BOOL isStartPlay;


@end

@implementation DFPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
//    IJKFFOptions* options = [IJKFFOptions optionsByDefault];
//    NSURL * url = [NSURL URLWithString:@"http://video.c-ctrip.com/live/daifeng.m3u8"];
//    
//    self.player = [[IJKFFMoviePlayerController alloc]initWithContentURL:url withOptions:options];
//    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
//    self.player.shouldAutoplay = YES;
//    
//    self.view.autoresizesSubviews = YES;
//    [self.view addSubview:self.player.view];
    self.isStartPlay = NO;
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.playerFatherView];
    
    [self setPlayerViewContraints];
    
    DFPlayerModel *model = [[DFPlayerModel alloc]init];
    //model.videoURL = [NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"];

    //model.videoURL = [NSURL URLWithString:@"http://video.c-ctrip.com/live/daifeng.m3u8"];
    model.videoURL = [NSURL URLWithString:@"http://video.c-ctrip.com/live/fdai.m3u8"];
    //model.videoURL = [NSURL URLWithString:@"http://video.c-ctrip.com/live/zwh.m3u8"];
    //model.videoURL = [NSURL URLWithString:@"http://114.80.149.151/sports.tc.qq.com/ArA5P8J2qNqrjOyT8tYGrF3N-DYNQIHdu564E4PCms6Q/l0024w4ryad.mp4?sdtfrom=v3010&guid=cd98485e4c15a650b745e8a046102da8&vkey=C0F025888DF55CABD714C71FD0CCFA556DF8BA22F16F44A6E13352A39668F76E300D196D2479253B4DF214FB86A228ADB0FEBA72C8029DE852D030D957493FA034F8C653E756F8D66C71961B0F3CBAF5B307C12BC6EE9AC6&platform=2"];
    DFPlayerVideoPlayer *player = [DFPlayerVideoPlayer videoPlayerWithView:self.playerFatherView delegate:self playerModel:model];
    self.player = player;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DebugLog(@"viewWillAppear");
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (self.player && self.isPlaying) {
        self.isPlaying = NO;
        [self.player playVideo];
    }
    [DFBrightnessView sharedBrightnessView].isStartPlay = self.isStartPlay;
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    DebugLog(@"vieWillDisappear");
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (self.player && !self.player.isPauseByUser) {
        self.isPlaying = YES;
        [self.player pauseVideo];
    }
    [DFBrightnessView sharedBrightnessView].isStartPlay = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DFPlayerVideoPlayerDelegate
-(void) playerBackButtonClick{
    [self.player destroyVideo];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) controlViewTapAction{
    if (_player) {
        [self.player autoPlayTheVideo];
        self.isStartPlay = YES;
    }
}

#pragma mark - 屏幕旋转
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self.playerFatherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
        }];
    }else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        [self.playerFatherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
        }];
    }
}

#pragma mark - set subview constraints
-(void) setPlayerViewContraints{
    if (IS_IPHONE_4) {
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(2.0f/3.0f);
        }];
    }else{
        [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
        }];
    }
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];

}

#pragma mark - getter

-(UIView*) topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor blackColor];
    }
    
    return _topView;
}

-(UIView*) playerFatherView{
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc]init];
    }
    return _playerFatherView;
}

-(DFPlayerModel*) playerModel{
    if (!_playerModel) {
        _playerModel = [[DFPlayerModel alloc]init];
    }
    return _playerModel;
}

-(void) dealloc{
    [self.player destroyVideo];
}
@end
