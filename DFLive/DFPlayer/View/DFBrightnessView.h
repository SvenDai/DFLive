//
//  DFBrightnessView.h
//  DFLive
//
//  Created by daifeng on 2017/9/19.
//  Copyright © 2017年 fdai. All rights reserved.
//  亮度改变视图

#import <UIKit/UIKit.h>

@interface DFBrightnessView : UIView

+(instancetype) sharedBrightnessView;

@property(nonatomic,assign) BOOL isLockScreen;
@property(nonatomic,assign) BOOL isStartPlay;

@end
