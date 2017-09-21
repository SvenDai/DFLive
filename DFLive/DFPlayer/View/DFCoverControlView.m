//
//  DFCoverControlView.m
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//  未播放状态下的封面

#import "DFCoverControlView.h"
#import "UIImageView+WebCache.h"

@interface DFCoverControlView ()

/**
 封面背景图片View
 */
@property (nonatomic,strong) UIImageView *backgroundImageView;

/**
 返回按钮
 */
@property (nonatomic,strong) UIButton *backBtn;

/**
 分享按钮
 */
@property (nonatomic,strong) UIButton *shareBtn;

/**
 播放按钮图片
 */
@property (nonatomic,strong) UIImageView *playerImageView;

@end

@implementation DFCoverControlView


-(instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.backBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.playerImageView];
        
        [self setSubViewConstrants];
        [self setSubViewAction];
    }
    return self;
}

#pragma mark public method
-(void) syncCoverImageViewWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholdImage{
    if (urlString.length) {
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholdImage];
    }else{
        self.backgroundImageView.image = placeholdImage;
    }
}

#pragma mark btn action
-(void) setSubViewAction{
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //封面图片添加手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundImageViewTapAction:)];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self.backgroundImageView addGestureRecognizer:tapGes];
}

-(void) backBtnClickAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(coverControlViewBackButtonClick)]) {
        [self.delegate performSelector:@selector(coverControlViewBackButtonClick)];
    }
}

-(void) shareBtnClickAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(coverControlViewShareButtionClick)]) {
        [self.delegate performSelector:@selector(coverControlViewShareButtionClick)];
    }
}

-(void) backgroundImageViewTapAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(coverControlViewBackgroundImageViewTapAction)]) {
        [self.delegate performSelector:@selector(coverControlViewBackgroundImageViewTapAction)];
    }
}

#pragma mark add subview constraints
-(void) setSubViewConstrants{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(2);
        make.left.equalTo(self.mas_left).offset(5);
        make.width.offset(52);
        make.height.offset(42);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(2);
        make.trailing.equalTo(self.mas_trailing).offset(-5);
        make.width.offset(52);
        make.height.offset(42);
    }];
    
    [self.playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(75);
    }];
}

#pragma mark - getter
-(UIImageView*) backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}

-(UIButton*) backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //#warning add res
        [_backBtn setImage:[UIImage imageNamed:@"dis_live_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

-(UIButton*) shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //#warning add res
        [_shareBtn setImage:[UIImage imageNamed:@"dis_live_share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

-(UIImageView*) playerImageView{
    if (!_playerImageView) {
        _playerImageView = [[UIImageView alloc]init];
        //#warning add res
        _playerImageView.image = [UIImage imageNamed:@"dis_live_playlogo"];
        _playerImageView.contentMode = UIViewContentModeCenter;
    }
    return _playerImageView;
}

@end

