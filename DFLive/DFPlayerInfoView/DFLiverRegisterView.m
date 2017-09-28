//
//  DFLiverRegisterView.m
//  DFLive
//
//  Created by daifeng on 2017/9/26.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFLiverRegisterView.h"
#import "UIColor+Hex.h"

@implementation DFLiverRegisterView


-(instancetype) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //设置ui
        [self setupUI];
        //设置子组件布局
        [self setSubviewConstraints];
        //设置组件响应时间
        [self setSubviewAciton];
    }
    return self;
}


#pragma mark - set subview action
-(void) setSubviewAciton{
    [self.coverImagBtn addTarget:self action:@selector(coverImagBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.submitBtn addTarget:self action:@selector(submitBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    // 开关事件切换通知
    [self.agreeLicenseSwitch addTarget:self action:@selector(agreeLicenseSwitchAction:) forControlEvents:UIControlEventValueChanged];
}
//action
-(void) coverImagBtnClickAction{
    if ([self.delegate respondsToSelector:@selector(RegisterCoverImagBtnClickAction)]) {
        [self.delegate RegisterCoverImagBtnClickAction];
    }
}

-(void) submitBtnClickAction{
    if ([self.delegate respondsToSelector:@selector(RegisterSubmitBtnClickAction)]) {
        [self.delegate RegisterSubmitBtnClickAction];
    }
}

-(void) agreeLicenseSwitchAction:(UISwitch*)sender{
    if ([self.delegate respondsToSelector:@selector(RegisterAgreeLicenseSwitchAction:)]) {
        [self.delegate RegisterAgreeLicenseSwitchAction:sender];
    }
}

#pragma mark - set up ui
-(void) setupUI{
    [self addSubview: self.coverImagBtn];
    [self.coverImagBtn addSubview: self.coverImagTipsLabel];
    
    [self addSubview: self.liveTitleTextField];
    [self addSubview: self.liveDescriptionTextField];
    [self addSubview: self.liveStartTimeLabel];
    [self addSubview: self.liveDurationLabel];
    
    [self addSubview: self.agreeLicenseLabel];
    [self addSubview: self.agreeLicenseSwitch];
    
    [self addSubview: self.submitBtn];
}


#pragma mark - set subview constraints
-(void) setSubviewConstraints{
    [self.coverImagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(5.0);
        make.height.width.mas_equalTo(120.0);
    }];

    [self.coverImagTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.coverImagBtn).offset(2);
        make.bottom.equalTo(self.coverImagBtn).offset(-2);
        //make.width.mas_equalTo(30);
        make.height.mas_equalTo(15);
    }];
    
    [self.liveTitleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.coverImagBtn.mas_trailing).offset(5);
        make.trailing.equalTo(self).offset(-5);
        make.top.equalTo(self).offset(5);
        make.height.mas_equalTo(120);
    }];
    
    [self.liveDescriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(5);
        make.top.equalTo(self.liveTitleTextField.mas_bottom).offset(5);
        make.trailing.equalTo(self).offset(-5);
        make.height.mas_equalTo(150);
    }];
    
    [self.liveStartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.liveDescriptionTextField.mas_bottom).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    [self.liveDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.liveStartTimeLabel.mas_bottom).offset(2);
        make.height.mas_equalTo(30);
    }];
    
    [self.agreeLicenseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self.liveDurationLabel.mas_bottom).offset(2);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(250);
    }];
    
    [self.agreeLicenseSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.agreeLicenseLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.agreeLicenseLabel.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
    }];
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeLicenseLabel.mas_bottom).offset(20);
        make.leading.equalTo(self).offset(5);
        make.trailing.equalTo(self).offset(-5);
        make.height.mas_equalTo(40);
    }];
}


#pragma mark - getter
-(UIButton*) coverImagBtn{
    if (!_coverImagBtn) {
        _coverImagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverImagBtn.backgroundColor = [UIColor colorWithHexString:@"0xbfbfbf"];
        
        [_coverImagBtn.imageView setImage:[UIImage imageNamed:@"dis_live_play"]];
    }
    return _coverImagBtn;
}

-(UILabel*) coverImagTipsLabel{
    if (!_coverImagTipsLabel) {
        _coverImagTipsLabel = [[UILabel alloc]init];
        [_coverImagTipsLabel setFont:[UIFont systemFontOfSize:10]];
        _coverImagTipsLabel.text = @"封面图片";
    }
    return _coverImagTipsLabel;
}

-(UITextField*) liveTitleTextField{
    if (!_liveTitleTextField) {
        _liveTitleTextField                     = [[UITextField alloc]init];
        _liveTitleTextField.placeholder         = @"请填写标题";
        _liveTitleTextField.layer.borderWidth    = 1;
        _liveTitleTextField.layer.borderColor    = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
    }
    return _liveTitleTextField;
}

-(UITextField*) liveDescriptionTextField{
    if (!_liveDescriptionTextField) {
        _liveDescriptionTextField               = [[UITextField alloc]init];
        _liveDescriptionTextField.placeholder   = @"请填写直播内容摘要";
        
        _liveDescriptionTextField.layer.borderWidth    = 1;
        _liveDescriptionTextField.layer.borderColor    = [UIColor colorWithHexString:@"0xbfbfbf"].CGColor;
    }
    return _liveDescriptionTextField;
}

-(UILabel*) liveStartTimeLabel{
    if (!_liveStartTimeLabel) {
        _liveStartTimeLabel = [[UILabel alloc]init];
        _liveStartTimeLabel.text = @"  开始直播时间";
    }
    return _liveStartTimeLabel;
}

-(UILabel*) liveDurationLabel{
    if (!_liveDurationLabel) {
        _liveDurationLabel = [[UILabel alloc]init];
        _liveDurationLabel.text = @"  预计时长";
    }
    return _liveDurationLabel;
}

-(UILabel*) agreeLicenseLabel{
    if (!_agreeLicenseLabel) {
        _agreeLicenseLabel = [[UILabel alloc]init];
        _agreeLicenseLabel.text = @"  同意程里人直播协议与章程";
    }
    return _agreeLicenseLabel;
}

-(UISwitch*) agreeLicenseSwitch{
    if (!_agreeLicenseSwitch) {
        _agreeLicenseSwitch = [[UISwitch alloc]init];
        _agreeLicenseSwitch.onTintColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _agreeLicenseSwitch;
}

-(UIButton*) submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _submitBtn.layer.cornerRadius  = 5;
        _submitBtn.layer.masksToBounds = YES;
        
        [_submitBtn setBackgroundColor:[UIColor colorWithHexString:@"0xFFCC66"]];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    return _submitBtn;
}
@end
