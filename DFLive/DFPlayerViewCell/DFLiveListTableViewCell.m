//
//  DFLiveListTableViewCell.m
//  DFLive
//
//  Created by daifeng on 2017/9/22.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFLiveListTableViewCell.h"
#import "UIColor+Hex.h"
#import "DFPlayer.h"


@interface DFLiveListTableViewCell ()

@property(nonatomic,strong) UIView *splitLine;

@end

@implementation DFLiveListTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void) setupUI{
    [self.contentView addSubview:self.liveCoverImageView];
    [self.contentView addSubview:self.splitLine];
    
    [self.liveCoverImageView addSubview:self.topView];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.videoStateBtn];
    
    [self.liveCoverImageView addSubview:self.playBtn];
    
    [self.liveCoverImageView addSubview:self.bottomView];

    [self.bottomView addSubview:self.videoLabel];

    [self.bottomView addSubview:self.liverName];
    [self.bottomView addSubview:self.viewerNum];
    
    [self.bottomView addSubview:self.timeLabel];
    
    [self setSubViewConstraints];
    [self setSubViewAction];
    
    [self insertTransparentGradient:self.bottomView withStartPoint:CGPointMake(0.5, 0) andEndPoint:CGPointMake(0.5, 1)];
    [self insertTransparentGradient:self.topView withStartPoint:CGPointMake(0.5, 1) andEndPoint:CGPointMake(0.5, 0)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - set up subveiw action
-(void) setSubViewAction{
    [self.liverName addTarget:self action:@selector(liverNameClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) liverNameClickAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(DFLiveListliverNameClickAction:)]) {
        [self.delegate DFLiveListliverNameClickAction:self];
    }
}

#pragma mark - set up subview contraints
-(void) setSubViewConstraints{
    [self.liveCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(1);
        make.trailing.equalTo(self.contentView).offset(-1);
        make.height.mas_equalTo(180.0);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.liveCoverImageView);
        make.width.height.mas_equalTo(60.0);
    }];
    
    [self.splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(5.0);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.liveCoverImageView);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(5.0);
        make.top.bottom.trailing.equalTo(self.topView);
    }];
    
    [self.videoStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-5.0);
        make.centerY.equalTo(self.topView.mas_centerY);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(60);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.liveCoverImageView);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY).offset(10);
        make.leading.mas_equalTo(5.0);
        make.height.mas_equalTo(20.0);
        make.width.mas_equalTo(50.0);
    }];
    
    [self.liverName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY).offset(10);
        make.leading.equalTo(self.videoLabel.mas_trailing).offset(10);
        make.height.mas_equalTo(30.0);
        make.width.mas_equalTo(65.0);
    }];
    
    [self.viewerNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY).offset(10);
        make.leading.equalTo(self.liverName.mas_trailing).offset(5);
        make.height.mas_equalTo(30.0);
        make.width.mas_equalTo(65.0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY).offset(10);
        make.trailing.equalTo(self.bottomView.mas_trailing).offset(-5);
        make.height.mas_equalTo(20.0);
        make.width.mas_equalTo(100.0);
    }];
    
}

#pragma mark - color confige
- (void) insertTransparentGradient:(UIView*)view withStartPoint:(CGPoint)sPoint andEndPoint:(CGPoint)ePoint{
    
    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.frame   = CGRectMake(0, 0, DF_SCREEN_WIDTH-2, 50);
    headerLayer.colors  = @[(id)[[UIColor clearColor] colorWithAlphaComponent:0.0f].CGColor,
                            (id)[[UIColor blackColor] colorWithAlphaComponent:0.5f].CGColor];
    headerLayer.startPoint  = sPoint;
    headerLayer.endPoint    = ePoint;
    [view.layer addSublayer:headerLayer];
}

#pragma mark - getter
-(UIImageView*) liveCoverImageView{
    if (!_liveCoverImageView) {
        _liveCoverImageView = [[UIImageView alloc]init];
        _liveCoverImageView.userInteractionEnabled = YES;
        //_liveCoverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _liveCoverImageView.contentMode =UIViewContentModeScaleAspectFill;
        _liveCoverImageView.clipsToBounds = YES;
    }
    return _liveCoverImageView;
}

-(UIView*) topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        //_topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return _topView;
}

-(UIButton*) videoStateBtn{
    if (!_videoStateBtn) {
        _videoStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _videoStateBtn.backgroundColor      = [UIColor redColor];
        _videoStateBtn.titleLabel.textColor = [UIColor whiteColor];
        _videoStateBtn.titleLabel.font      = [UIFont systemFontOfSize:10];
        [_videoStateBtn setTitle:@"直播中" forState:UIControlStateNormal];
        
        _videoStateBtn.layer.cornerRadius   = 8;
        _videoStateBtn.layer.masksToBounds  = YES;

        _videoStateBtn.titleLabel.frame = CGRectMake(0, 0, 30, 15);
        _videoStateBtn.imageView.frame  = CGRectMake(0, 0, 5, 5);
        
        _videoStateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        _videoStateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [_videoStateBtn setImage:[UIImage imageNamed:@"dis_llist_livelogo"] forState:UIControlStateNormal];
    }
    return _videoStateBtn;
}

-(UIButton*) playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        _playBtn.userInteractionEnabled = NO;
        [_playBtn setImage:[UIImage imageNamed:@"dis_live_listplay"] forState:UIControlStateNormal];
    }
    return _playBtn;
}

-(UILabel*) videoLabel{
    if (!_videoLabel) {
        _videoLabel = [[UILabel alloc] init];
        [_videoLabel setTextColor:[UIColor whiteColor]];
        _videoLabel.font = [UIFont systemFontOfSize:14];
    }
    return _videoLabel;
}

-(UILabel*) titleLabel{
    if (!_titleLabel) {
        _titleLabel     = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel setTextColor:[UIColor whiteColor]];
    }
    return _titleLabel;
}

-(UIView*) bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        //_bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return _bottomView;
}

-(UIButton*) liverName{
    if (!_liverName) {
        _liverName = [UIButton buttonWithType:UIButtonTypeCustom];
        _liverName.titleLabel.textColor = [UIColor whiteColor];
        _liverName.titleLabel.font      = [UIFont systemFontOfSize:14];
        
        [_liverName setImage:[UIImage imageNamed:@"dis_llist_livelogo"] forState:UIControlStateNormal];
        
        _liverName.titleLabel.frame = CGRectMake(0, 0, 30, 30);
        _liverName.imageView.frame  = CGRectMake(35, 0, 30, 30);
        
        _liverName.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        _liverName.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    }
    return _liverName;
}


-(UIButton*) viewerNum{
    if (!_viewerNum) {
        _viewerNum = [UIButton buttonWithType:UIButtonTypeCustom];
        [_viewerNum setTitleColor: [UIColor colorWithHexString:@"0xFED946"] forState:UIControlStateNormal];
        _viewerNum.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_viewerNum setImage:[UIImage imageNamed:@"dis_llist_viewerlogo"] forState:UIControlStateNormal];
        
        _viewerNum.titleLabel.frame = CGRectMake(0, 0, 30, 30);
        _viewerNum.imageView.frame  = CGRectMake(35, 0, 30, 30);
        
        _viewerNum.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        _viewerNum.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    }
    return _viewerNum;
}

-(UILabel*) timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        
        _timeLabel.textAlignment    = NSTextAlignmentRight;
        _timeLabel.font             = [UIFont systemFontOfSize:14];
    }
    return _timeLabel;
}

-(UIView*)splitLine{
    if (!_splitLine) {
        _splitLine = [UIView new];
        _splitLine.backgroundColor = [UIColor whiteColor];
    }
    return _splitLine;
}
@end
