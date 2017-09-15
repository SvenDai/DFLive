//
//  DFCoverControlView.h
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFCoverControlViewDelegate <NSObject>


/**
 返回按钮被点击
 */
-(void)coverControlViewBackButtonClick;

/**
 分享按钮被点击
 */
-(void)coverControlViewShareButtionClick;

/**
 封面图片的点击事件
 */
-(void)coverControlViewBackgroundImageViewTapAction;

@end

@interface DFCoverControlView : UIView

@property (nonatomic,weak) id<DFCoverControlViewDelegate> delegate;

/**
 同步封面图片

 @param urlString 封面图片路径
 @param placeholdImage 占位图
 */
-(void) syncCoverImageViewWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholdImage;

@end
