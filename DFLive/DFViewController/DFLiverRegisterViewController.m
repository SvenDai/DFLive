//
//  DFLiverRegisterViewController.m
//  DFLive
//
//  Created by daifeng on 2017/9/26.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFLiverRegisterViewController.h"
#import "DFLiverRegisterView.h"
#import "UIColor+Hex.h"

@interface DFLiverRegisterViewController ()<DFLiverRegisterViewDelegate>

@property(nonatomic,strong) DFLiverRegisterView *liverRegisterView;

@end

@implementation DFLiverRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//set up ui
-(void) setupUI{
    [self.view addSubview: self.liverRegisterView];
    [self.liverRegisterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

#pragma mark - DFLiverRegisterViewDelegate
-(void) RegisterSubmitBtnClickAction{
    DebugLog(@"submit btn click");
}

-(void) RegisterCoverImagBtnClickAction{
    DebugLog(@"img btn click");
}

-(void) RegisterAgreeLicenseSwitchAction:(UISwitch *)rswitch{
    DebugLog(@"switch action");
    BOOL isagree = [rswitch isOn];
    if (isagree) {
        self.liverRegisterView.submitBtn.userInteractionEnabled = YES;
        self.liverRegisterView.submitBtn.backgroundColor        = [UIColor colorWithHexString:@"0x666666"];
        [self.liverRegisterView.agreeLicenseSwitch setOn:NO];
    }else{
        self.liverRegisterView.submitBtn.backgroundColor        = [UIColor colorWithHexString:@"0xFFCC66"];
        self.liverRegisterView.submitBtn.userInteractionEnabled = NO;
        [self.liverRegisterView.agreeLicenseSwitch setOn:YES];
    }
}

#pragma mark - getter
-(DFLiverRegisterView*) liverRegisterView{
    if (!_liverRegisterView) {
        _liverRegisterView = [[DFLiverRegisterView alloc]init];
        _liverRegisterView.delegate = self;
    }
    return _liverRegisterView;
}


@end
