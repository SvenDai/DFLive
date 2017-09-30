//
//  DFLiveDetailInfoView.h
//  DFLive
//
//  Created by daifeng on 2017/9/30.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFLiveDetailInfoView : UIView

@property(nonatomic,strong) UIView          *toolbarView;

@property(nonatomic,strong) UIImageView     *liverHeadView;

@property(nonatomic,strong) UILabel         *liverNameLabel;

@property(nonatomic,strong) UIButton        *fullScreenBtn;

@property(nonatomic,strong) UIButton        *chatBtn;

@property(nonatomic,strong) UIButton        *shareBtn;

@property(nonatomic,strong) UIView          *descriptionView;

@property(nonatomic,strong) UILabel         *descriptionTitleLabel;

@property(nonatomic,strong) UILabel         *descriptionContentLabel;

@property(nonatomic,strong) UIButton        *remindMeBtn;

@end
