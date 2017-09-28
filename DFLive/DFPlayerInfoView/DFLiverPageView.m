//
//  DFLiverPageView.m
//  DFLive
//
//  Created by daifeng on 2017/9/25.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFLiverPageView.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Hex.h"

@interface DFLiverPageView ()

@end

@implementation DFLiverPageView

-(instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview: self.liverHeadImage];
        [self addSubview: self.liverNameLabel];
        [self addSubview: self.addNewLiveBtn];
        [self addSubview: self.tableViewHeadView];
        
        [self setSubviewConstraints];
        
        [self setSubviewAction];
    }
    return self;
}


-(void) setSubviewAction{
    [self.addNewLiveBtn addTarget:self action:@selector(addNewLiveBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(liverHeadImageTapAction:)];
    self.liverHeadImage.userInteractionEnabled = YES;
    [self.liverHeadImage  addGestureRecognizer:tap];
}

-(void) addNewLiveBtnClickAction{
    if ([self.delegate respondsToSelector:@selector(addNewLiveBtnClick)]) {
        [self.delegate addNewLiveBtnClick];
    }
}

-(void) liverHeadImageTapAction:(UITapGestureRecognizer*) tap{
    if ([self.delegate respondsToSelector:@selector(liverHeadViewTap:)]) {
        [self.delegate liverHeadViewTap:tap];
    }
}

#pragma mark - set up subview contraints
-(void) setSubviewConstraints{
    [self.liverHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-15);
        make.leading.equalTo(self.mas_leading).offset(5);
        make.height.width.mas_equalTo(60);
    }];
    
    [self.liverNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.liverHeadImage.mas_centerY);
        make.leading.equalTo(self.liverHeadImage.mas_trailing).offset(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
    
    [self.addNewLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.liverHeadImage.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
    }];
    
    [self.tableViewHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(2);
        make.trailing.equalTo(self.mas_trailing).offset(-2);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - getter
-(UIImageView*) liverHeadImage{
    if (!_liverHeadImage) {
        _liverHeadImage = [[UIImageView alloc]init];
        _liverHeadImage.layer.cornerRadius  = 20;
        _liverHeadImage.layer.masksToBounds = YES;
    }
    return _liverHeadImage;
}

-(UILabel*) liverNameLabel{
    if (!_liverNameLabel) {
        _liverNameLabel = [[UILabel alloc]init];
    }
    return _liverNameLabel;
}

-(UIButton*) addNewLiveBtn{
    if (!_addNewLiveBtn) {
        _addNewLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _addNewLiveBtn.backgroundColor      = [UIColor colorWithHexString:@"0xFFCC66"];
        _addNewLiveBtn.titleLabel.textColor = [UIColor whiteColor];
        _addNewLiveBtn.layer.cornerRadius   = 2.0;
        _addNewLiveBtn.layer.masksToBounds  = YES;
        
        [_addNewLiveBtn setTitle:@"发起直播" forState:UIControlStateNormal];
    }
    return _addNewLiveBtn;
}

-(UILabel*) tableViewHeadView{
    if (!_tableViewHeadView) {
        _tableViewHeadView                 = [[UILabel alloc]init];
        _tableViewHeadView.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        _tableViewHeadView.textColor       = [UIColor colorWithHexString:@"0x888888"];
        _tableViewHeadView.text            = @"我的直播";
    }
    return _tableViewHeadView;
}
@end
