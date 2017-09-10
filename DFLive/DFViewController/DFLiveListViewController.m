//
//  DFLiveListViewController.m
//  DFLive
//
//  Created by daifeng on 2017/9/4.
//  Copyright © 2017年 daifeng. All rights reserved.
//

#import "DFLiveListViewController.h"
#import "Masonry.h"
#import "DFPlayerViewController.h"

@interface DFLiveListViewController ()

@property(nonatomic,strong) UIButton *playerViewBtn;

@end

@implementation DFLiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.playerViewBtn];
    [self setViewConts];
}

-(void)setViewConts{
    [self.playerViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(70.0f);
    }];
}

- (UIButton*) playerViewBtn{
    if (!_playerViewBtn) {
        _playerViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playerViewBtn.backgroundColor = [UIColor redColor];
        [_playerViewBtn setTitle:@"播放页" forState:UIControlStateNormal];
        [_playerViewBtn addTarget:self action:@selector(gotoPlayerViewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playerViewBtn;
}

- (void) gotoPlayerViewAction:(id)sender{
    DFPlayerViewController *playerViewVC = [[DFPlayerViewController alloc]init];
    [self.navigationController pushViewController:playerViewVC animated:YES];
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
