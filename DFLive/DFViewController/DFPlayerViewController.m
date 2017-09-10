//
//  DFPlayerViewController.m
//  DFLive
//
//  Created by daifeng on 2017/9/8.
//  Copyright © 2017年 daifeng. All rights reserved.
//

#import "DFPlayerViewController.h"
#import "IJKMediaFramework/IJKMediaFramework.h"

@interface DFPlayerViewController ()

@property(nonatomic,strong) IJKFFMoviePlayerController *player;
@property(nonatomic,weak)   UIView *playerView;

@end

@implementation DFPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    IJKFFOptions* options = [IJKFFOptions optionsByDefault];
    NSURL * url = [NSURL URLWithString:@"http://video.c-ctrip.com/live/daifeng.m3u8"];
    
    self.player = [[IJKFFMoviePlayerController alloc]initWithContentURL:url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DebugLog(@"viewWillAppear");
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
        //[self.player play];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    DebugLog(@"vieWillDisappear");
    [self.player shutdown];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
