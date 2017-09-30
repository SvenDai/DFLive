//
//  DFLiveDetailInfoView.m
//  DFLive
//
//  Created by daifeng on 2017/9/30.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFLiveDetailInfoView.h"

@implementation DFLiveDetailInfoView

#pragma mark - getter
-(UIView*) toolbarView{
    if (!_toolbarView) {
        _toolbarView = [[UIView alloc]init];
    }
    return _toolbarView;
}

-(UIImageView*) liverHeadView{
    if (!_liverHeadView) {
        _liverHeadView = [[UIImageView alloc]init];
        
        _liverHeadView.layer.cornerRadius   = 10;
        _liverHeadView.layer.masksToBounds  = YES;
    }
    return _liverHeadView;
}

-(UILabel*) liverNameLabel{
    if (!_liverNameLabel) {
        _liverNameLabel = [[UILabel alloc]init];
    }
    return _liverNameLabel;
}

-(UIButton*) fullScreenBtn{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _fullScreenBtn;
}


-(UIButton*) chatBtn{
    if (!_chatBtn) {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _chatBtn;
}

-(UIButton*) shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

-(UIView*) descriptionView{
    if (!_descriptionView) {
        _descriptionView = [[UIView alloc]init];
    }
    return _descriptionView;
}

-(UILabel*) descriptionTitleLabel{
    if (!_descriptionTitleLabel) {
        _descriptionTitleLabel = [[UILabel alloc]init];
    }
    return _descriptionTitleLabel;
}

-(UILabel*) descriptionContentLabel{
    if (!_descriptionContentLabel) {
        _descriptionContentLabel = [[UILabel alloc]init];
    }
    return _descriptionContentLabel;
}

-(UIButton*) remindMeBtn{
    if (!_remindMeBtn) {
        _remindMeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _remindMeBtn.backgroundColor = [UIColor redColor];
    }
    return _remindMeBtn;
}
@end
