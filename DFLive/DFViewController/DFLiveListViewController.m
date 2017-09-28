//
//  DFLiveListViewController.m
//  DFLive
//
//  Created by daifeng on 2017/9/4.
//  Copyright © 2017年 daifeng. All rights reserved.
//

#import "DFLiveListViewController.h"
#import "DFPlayerViewController.h"
#import "DFLiveListTableViewCell.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"
#import "DFLiverPersonalPageViewController.h"

static NSString *liveCellId = @"LIVECELLID";

@interface DFLiveListViewController ()<UITableViewDelegate,UITableViewDataSource,DFLiveListTableViewCellDelegate>

@property(nonatomic,strong) UIButton *playerViewBtn;

@property(nonatomic,strong) UITableView  *tableView;
@property(nonatomic,strong) UIButton     *myLivePageBtn;

@end

@implementation DFLiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupUI];
}

-(void) setupUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.myLivePageBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.trailing.mas_equalTo(0);
    }];
    
    [self.myLivePageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.trailing.equalTo(self.view.mas_trailing).offset(-5.0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50.0);
    }];
    [self.view bringSubviewToFront:self.myLivePageBtn];
}

#pragma mark - getter
-(UITableView*) tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf4f4f4"];
        
        [_tableView registerClass:[DFLiveListTableViewCell class] forCellReuseIdentifier:liveCellId];
        
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

-(UIButton*) myLivePageBtn{
    if (!_myLivePageBtn) {
        _myLivePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_myLivePageBtn setImage:[UIImage imageNamed:@"dis_live_listplay"] forState:UIControlStateNormal];
        [_myLivePageBtn addTarget:self action:@selector(myLivePageBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _myLivePageBtn.backgroundColor     = [UIColor colorWithHexString:@"0x000000" alpha:0.3];
        _myLivePageBtn.layer.cornerRadius  = 20.0;
        _myLivePageBtn.layer.masksToBounds = YES;
    }
    return _myLivePageBtn;
}

#pragma mark - UITableViewDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DFLiveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:liveCellId forIndexPath:indexPath];
    cell.delegate = self;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:liveCellId forIndexPath:indexPath];
    }
    
    [cell.liveCoverImageView  sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"dis_live_cover"]];
    
    cell.titleLabel.text = @"直播测试测试";
    cell.videoLabel.text = @"Live";
    
    [cell.liverName setTitle:@"代风" forState:UIControlStateNormal];

    [cell.viewerNum setTitle:@"1000" forState:UIControlStateNormal];
    
    cell.timeLabel.text = @"今天 15:00";
    
    [cell insertTransparentGradient:cell.bottomView];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated: YES];
    [self gotoPlayerViewAction:nil];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185.0f;
}

#pragma mark - DFLiveListtTableViewCellDelegate
-(void) DFLiveListliverNameClickAction:(DFLiveListTableViewCell *)cell{
    DebugLog(@"liver name click");
}

#pragma mark - btn aciton
- (void) gotoPlayerViewAction:(id)sender{
    DFPlayerViewController *playerViewVC = [[DFPlayerViewController alloc]init];
    [self.navigationController pushViewController:playerViewVC animated:YES];
}

-(void) myLivePageBtnClickAction:(UIButton*)sender{
    DebugLog(@"my live page btn click");
    DFLiverPersonalPageViewController *personalPageViewController = [[DFLiverPersonalPageViewController alloc]init];
    [self.navigationController pushViewController:personalPageViewController animated:YES];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
