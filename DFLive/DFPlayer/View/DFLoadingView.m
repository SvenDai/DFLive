//
//  DFLoadingView.m
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFLoadingView.h"

@interface DFLoadingView ()

@property(nonatomic,strong) UIButton *backBtn;

@property(nonatomic,strong) UIButton *shareBtn;

@property(nonatomic,strong) MMMaterialDesignSpinner *activity;

@end

@implementation DFLoadingView


-(instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.backBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.activity];
        
        [self setSubviewConstraints];
        [self setSubViewAction];
        
        [self.activity startAnimating];
        
        //拦截手势
        [self interceptGesture];
    }
    return self;
}

#pragma mark - 拦截手势
-(void) interceptGesture{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction)];
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    
    UIPanGestureRecognizer *panTap = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTapAction)];
    [self addGestureRecognizer:panTap];
}

-(void) singleTapAction{}
-(void) doubleTapAction{}
-(void) panTapAction{}

#pragma mark - set subview action
-(void) setSubViewAction{
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn addTarget:self action:@selector(shareBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) backBtnClickAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(loadingViewBackButtonClick)]) {
        [self.delegate performSelector:@selector(loadingViewBackButtonClick)];
    }
}

-(void) shareBtnClickAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(loadingViewShareButonClick)]) {
        [self.delegate performSelector:@selector(loadingViewShareButonClick)];
    }
}

#pragma mark - add subview constraints
-(void) setSubviewConstraints{
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
        make.width.offset(42);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(45);
    }];
}

#pragma mark - getter
-(UIButton*) backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        #warning add res
        [_backBtn setImage:[UIImage imageNamed:@"dis_live_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

-(UIButton*) shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        #warning add res
        [_shareBtn setImage:[UIImage imageNamed:@"dis_live_share"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

-(MMMaterialDesignSpinner*) activity{
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc]init];
        _activity.lineWidth = 1;
        _activity.duration = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}
@end
