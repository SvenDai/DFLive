//
//  DFMainNavViewController.m
//  DFLive
//
//  Created by daifeng on 2017/9/4.
//  Copyright © 2017年 daifeng. All rights reserved.
//

#import "DFMainNavViewController.h"
#import "DFPlayerViewController.h"
#import "DFPlayer.h"

@interface DFMainNavViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic,strong) id popDelegate;

@end

@implementation DFMainNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count == 1) { //根控制器
        //如果是根控制器，设回手势代理
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }
}

-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count != 0) { //非根控制器
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:0 target:self action:@selector(back)];
        
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    [super pushViewController:viewController animated:animated];
}

-(void)back{
    [self popViewControllerAnimated:YES];
}

#pragma mark - 控制转屏
// 哪些页面支持自动转屏
- (BOOL)shouldAutorotate{
    
    // LMPlayViewController 控制器支持自动转屏
    if ([self.topViewController isKindOfClass:[DFPlayerViewController class]]) {

        return YES;
    }
    return NO;
}

// viewcontroller支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if ([self.topViewController isKindOfClass:[DFPlayerViewController class]]) { // LMPlayViewController这个页面支持转屏方向
        if ([DFBrightnessView sharedBrightnessView].isStartPlay) {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        } else {
            return UIInterfaceOrientationMaskPortrait;
        }
        
    }
    // 其他页面
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
@end
