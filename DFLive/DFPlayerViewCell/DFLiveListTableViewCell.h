//
//  DFLiveListTableViewCell.h
//  DFLive
//
//  Created by daifeng on 2017/9/22.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DFLiveListTableViewCell;

@protocol DFLiveListTableViewCellDelegate <NSObject>

-(void) DFLiveListliverNameClickAction:(DFLiveListTableViewCell*) cell;

@end

@interface DFLiveListTableViewCell : UITableViewCell

@property(nonatomic,weak) id<DFLiveListTableViewCellDelegate>delegate;

@property(nonatomic,strong) UIImageView *liveCoverImageView;

@property(nonatomic,strong) UIView      *topView;

@property(nonatomic,strong) UIButton    *playBtn;

@property(nonatomic,strong) UILabel     *videoLabel;

@property(nonatomic,strong) UILabel     *titleLabel;

@property(nonatomic,strong) UIView      *bottomView;

@property(nonatomic,strong) UIButton    *liverName;

@property(nonatomic,strong) UIButton    *viewerNum;

@property(nonatomic,strong) UILabel     *timeLabel;

-(void) insertTransparentGradient:(UIView*)view;

@end
