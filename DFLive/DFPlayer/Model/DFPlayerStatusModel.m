//
//  DFPlayerStatusModel.m
//  DFLive
//
//  Created by daifeng on 2017/9/14.
//  Copyright © 2017年 fdai. All rights reserved.
//

#import "DFPlayerStatusModel.h"

@implementation DFPlayerStatusModel

-(void) playerResetStatusModel{
    self.autoPlay    = NO;
    self.playDidEnd  = NO;
    self.dragged     = NO;

    self.pauseByUser = NO;
    self.fullScreen  = NO;
    
    self.didEnterBackground = NO;
}

@end
