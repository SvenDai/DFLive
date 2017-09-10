//
//  DFMainTabBarViewController.m
//  DFLive
//
//  Created by daifeng on 2017/9/4.
//  Copyright © 2017年 daifeng. All rights reserved.
//

#import "DFMainTabBarViewController.h"
#import "DFMainNavViewController.h"
#import "DFLiveListViewController.h"
#import "DFSelfInfoViewController.h"

@interface DFMainTabBarViewController ()

@end

@implementation DFMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DFLiveListViewController *liveListVC = [[DFLiveListViewController alloc]init];
    [self addChildViewControllerWithTitle:@"直播" viewController:liveListVC imageName:@"dis_live" selImageName:@"dis_live_sel"];
    
    DFSelfInfoViewController* selfInfoVC = [[DFSelfInfoViewController alloc]init];
    [self addChildViewControllerWithTitle:@"关于我" viewController:selfInfoVC imageName:@"dis_about_me" selImageName:@"dis_about_me_sel"];
    self.selectedIndex = 0;
}

-(void) addChildViewControllerWithTitle:(NSString*)title viewController:(UIViewController*)vc imageName:(NSString*) imageName selImageName:(NSString*) selImageName{
    
    [vc.tabBarItem setTitle:title];
    [vc.tabBarItem setImage:[UIImage imageNamed:imageName]];
    [vc.tabBarItem setSelectedImage:[self imageWithOriginaRenderingMode:selImageName]];
    
//    NSMutableDictionary *textArrays = [NSMutableDictionary dictionary];
//    textArrays[NSForegroundColorAttributeName] = [UIColor yellowColor];
//    [vc.tabBarItem setTitleTextAttributes:textArrays forState:UIControlStateNormal];
//    [vc.tabBarItem setTitleTextAttributes:textArrays forState:UIControlStateHighlighted];
    
    DFMainNavViewController *mainNavVC = [[DFMainNavViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:mainNavVC];
}

/**
 * 加载原始图片，不被系统渲染
 * @param imageName 图片名称
 * @return 原始图片
 */
-(UIImage*) imageWithOriginaRenderingMode:(NSString*)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
