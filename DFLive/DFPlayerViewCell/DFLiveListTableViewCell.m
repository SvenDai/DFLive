//
//  DFLiveListTableViewCell.m
//  DFLive
//
//  Created by daifeng on 2017/9/22.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFLiveListTableViewCell.h"


@interface DFLiveListTableViewCell ()

@property(nonatomic,strong) UIImageView *liveCoverImageView;

@property(nonatomic,strong) UIView      *topView;

@property(nonatomic,strong) UILabel     *videoLabel;

@property(nonatomic,strong) UILabel     *titleLabel;

@property(nonatomic,strong) UIView      *bottomView;

@property(nonatomic,strong) UIImageView *liveLogo;

@property(nonatomic,strong) UILabel     *liverName;

@property(nonatomic,strong) UIImageView *viewerLogo;

@property(nonatomic,strong) UILabel     *viewerNum;

@property(nonatomic,strong) UILabel     *timeLabel;

@end

@implementation DFLiveListTableViewCell

-(instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void) setupUI{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setSubViewAction{
    
}

-(void) setSubViewConstraints{
    [self.liveCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.contentView);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.liveCoverImageView);
    }];
}

#pragma mark - getter
-(UIImageView*) liveCoverImageView{
    if (!_liveCoverImageView) {
        _liveCoverImageView = [[UIImageView alloc]init];
    }
    return _liveCoverImageView;
}

-(UIView*) topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _topView;
}

-(UILabel*) videoLabel{
    if (!_videoLabel) {
        _videoLabel = [[UILabel alloc] init];
        [_videoLabel setTextColor:[UIColor whiteColor]];
    }
    return _videoLabel;
}

-(UILabel*) titleLabel{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc]init];
        [_titleLabel setTextColor:[UIColor whiteColor]];
    }
    return _titleLabel;
}

-(UIView*) bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _bottomView;
}

-(UIImageView*) liveLogo{
    if (!_liveLogo) {
        _liveLogo = [[UIImageView alloc]init];
        [_liveLogo setImage:[UIImage imageNamed:@"dis_live_list_livelogo"]];
    }
    return _liveLogo;
}

-(UILabel*) liverName{
    if (!_liverName) {
        _liverName = [[UILabel alloc]init];
        [_liverName setTextColor:[UIColor whiteColor]];
    }
    return _liverName;
}

-(UIImageView*) viewerLogo{
    if (!_viewerLogo) {
        _viewerLogo = [[UIImageView alloc]init];
        [_viewerLogo setImage:[UIImage imageNamed:@"dis_live_list_viewerlogo"]];
    }
    return _viewerLogo;
}

-(UILabel*) viewerNum{
    if (!_viewerNum) {
        _viewerNum = [[UILabel alloc]init];
        [_viewerNum setTextColor:[UIColor whiteColor]];
    }
    return _viewerNum;
}

-(UILabel*) timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [_timeLabel setTextColor:[UIColor whiteColor]];
    }
    return _timeLabel;
}
@end
