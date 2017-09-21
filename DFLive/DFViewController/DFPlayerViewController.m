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
    model.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
    //model.videoURL = [NSURL URLWithString:@"http://video.c-ctrip.com/live/daifeng.m3u8"];
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
