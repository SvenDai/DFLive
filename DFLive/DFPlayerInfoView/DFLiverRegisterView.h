//
//  DFLiverRegisterView.h
//  DFLive
//
//  Created by daifeng on 2017/9/26.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFLiverRegisterViewDelegate <NSObject>

-(void) RegisterSubmitBtnClickAction;

-(void) RegisterCoverImagBtnClickAction;

-(void) RegisterAgreeLicenseSwitchAction:(UISwitch*)rswitch;

@end

@interface DFLiverRegisterView : UIView

@property(nonatomic,strong) id<DFLiverRegisterViewDelegate>delegate;

@property(nonatomic,strong) UIButton    *coverImagBtn;

@property(nonatomic,strong) UILabel     *coverImagTipsLabel;

@property(nonatomic,strong) UITextField *liveTitleTextField;

@property(nonatomic,strong) UITextField *liveDescriptionTextField;

@property(nonatomic,strong) UILabel     *liveStartTimeLabel;

@property(nonatomic,strong) UILabel     *liveDurationLabel;

@property(nonatomic,strong) UILabel     *agreeLicenseLabel;

@property(nonatomic,strong) UISwitch    *agreeLicenseSwitch;

@property(nonatomic,strong) UIButton    *submitBtn;

@end
