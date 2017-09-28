//
//  DFLiverPersonalPageViewController.m
//  DFLive
//
//  Created by daifeng on 2017/9/25.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFLiverPersonalPageViewController.h"
#import "DFLiverPageView.h"
#import "UIImageView+WebCache.h"
#import "DFLiveListTableViewCell.h"
#import "DFPlayerViewController.h"
#import "DFLiverRegisterViewController.h"

static NSString *liverHistoryVideoCellId  = @"LIVERHISTORYVIDEOCELLID";

@interface DFLiverPersonalPageViewController ()<DFLiverPageViewDelegate,UITableViewDelegate,UITableViewDataSource,DFLiveListTableViewCellDelegate>

@property(nonatomic,strong) UITableView     *tableView;

@property(nonatomic,strong) DFLiverPageView *liverInfoView;

@end

@implementation DFLiverPersonalPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self.liverInfoView.liverHeadImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"dis_live_pause"]];
    self.liverInfoView.liverNameLabel.text = @"张三";
    
}

-(void) setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.liverInfoView];
    [self.liverInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(110);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.liverInfoView.mas_bottom).offset(1);
        make.leading.equalTo(self.view).offset(1);
        make.trailing.equalTo(self.view).offset(-1);
        make.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DFLiveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:liverHistoryVideoCellId forIndexPath:indexPath];
    cell.delegate = self;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:liverHistoryVideoCellId forIndexPath:indexPath];
    }
    
    [cell.liveCoverImageView  sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"dis_live_cover"]];
    
    cell.titleLabel.text = @"直播测试测试";
    cell.videoLabel.text = @"LIVE";
    
    [cell.liverName setTitle:@"代风" forState:UIControlStateNormal];

    [cell.viewerNum setTitle:@"1000" forState:UIControlStateNormal];
    
    cell.timeLabel.text = @"今天 15.00";
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self gotoPlayerViewAction:nil];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185.0f;
}

#pragma mark DFLiveListTableViewCellDelegate
-(void) DFLiveListliverNameClickAction:(DFLiveListTableViewCell *)cell{
    DebugLog(@"optional impl");
}

#pragma mark - DFLiverPageViewDelegate
-(void) addNewLiveBtnClick{
    DebugLog(@"add new live btn click");
    DFLiverRegisterViewController *liverRegisterVC = [[DFLiverRegisterViewController alloc]init];
    [self.navigationController pushViewController:liverRegisterVC animated:YES];
}

#pragma mark - btn aciton
- (void) gotoPlayerViewAction:(id)sender{
    DFPlayerViewController *playerViewVC = [[DFPlayerViewController alloc]init];
    [self.navigationController pushViewController:playerViewVC animated:YES];
}

#pragma mark - getter
-(DFLiverPageView*)liverInfoView{
    if (!_liverInfoView) {
        _liverInfoView = [[DFLiverPageView alloc] init];
        _liverInfoView.delegate = self;
    }
    return _liverInfoView;
}

-(UITableView*) tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[DFLiveListTableViewCell class] forCellReuseIdentifier:liverHistoryVideoCellId];
        
        _tableView.delegate     = self;
        _tableView.dataSource   = self;
    }
    return _tableView;
}

@end
