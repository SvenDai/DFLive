//
//  DFLoadingView.h
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMaterialDesignSpinner.h"

@protocol DFLoadingViewDelegate <NSObject>

/**
 返回按钮点击事件
 */
-(void) loadingViewBackButtonClick;

/**
 分享按钮点击事件
 */
-(void) loadingViewShareButonClick;

@end

@interface DFLoadingView : UIView
@property(nonatomic,weak) id<DFLoadingViewDelegate> delegate;
@end
