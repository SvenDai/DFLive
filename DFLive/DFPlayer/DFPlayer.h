//
//  DFPlayer.h
//  DFLive
//
//  Created by daifeng on 2017/9/11.
//  Copyright © 2017年 fdai. All rights reserved.
//

//屏幕信息
#define DF_SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define DF_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define DF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

// 机型
#define SCREEN_MAX_LENGTH (MAX(DF_SCREEN_WIDTH, DF_SCREEN_HEIGHT))
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4  (IS_IPHONE && SCREEN_MAX_LENGTH == 480.0)
