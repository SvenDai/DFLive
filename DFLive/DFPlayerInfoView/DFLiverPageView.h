//
//  DFLiverPageView.h
//  DFLive
//
//  Created by daifeng on 2017/9/25.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFLiverPageViewDelegate <NSObject>

@required
-(void) addNewLiveBtnClick;

@optional
-(void) liverHeadViewTap:(UIGestureRecognizer*) tap;

@end

@interface DFLiverPageView : UIView

@property(nonatomic,strong) id<DFLiverPageViewDelegate>delegate;

@property(nonatomic,strong) UIImageView *liverHeadImage;

@property(nonatomic,strong) UILabel     *liverNameLabel;

@property(nonatomic,strong) UIButton    *addNewLiveBtn;

@property(nonatomic,strong) UILabel     *tableViewHeadView;

@end
