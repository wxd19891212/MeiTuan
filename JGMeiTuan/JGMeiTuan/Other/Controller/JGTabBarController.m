//
//  JGTabBarController.m
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/31.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import "JGTabBarController.h"
#import "JGHomeViewController.h"
#import "JGOnSiteViewController.h"
#import "JGMerchantViewController.h"
#import "JGMineViewController.h"
#import "JGMoreViewController.h"
#import "JGNavigationController.h"


@interface JGTabBarController ()

@end

@implementation JGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];


    JGHomeViewController *VC1 = [[JGHomeViewController alloc] init];
    JGNavigationController *nav1 = [[JGNavigationController alloc] initWithRootViewController:VC1];
    JGOnSiteViewController *VC2 = [[JGOnSiteViewController alloc] init];
    JGNavigationController *nav2 = [[JGNavigationController alloc] initWithRootViewController:VC2];
    JGMerchantViewController *VC3 = [[JGMerchantViewController alloc] init];
    JGNavigationController *nav3 = [[JGNavigationController alloc] initWithRootViewController:VC3];
    JGMineViewController *VC4 = [[JGMineViewController alloc] init];
    JGNavigationController *nav4 = [[JGNavigationController alloc] initWithRootViewController:VC4];
    JGMoreViewController *VC5 = [[JGMoreViewController alloc] init];
    JGNavigationController *nav5 = [[JGNavigationController alloc] initWithRootViewController:VC5];
    VC1.title = @"团购";
    VC2.title = @"上门";
    VC3.title = @"商家";
    VC4.title = @"我的";
    VC5.title = @"更多";
    
    self.viewControllers = @[nav1, nav2, nav3, nav4, nav5];
    
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *item4 = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *item5 = [self.tabBar.items objectAtIndex:4];
    
    item1.selectedImage = [self getImageFormStr:@"icon_tabbar_homepage_selected"];
    item1.image = [self getImageFormStr:@"icon_tabbar_homepage"];
    item2.selectedImage = [self getImageFormStr:@"icon_tabbar_onsite_selected"];
    item2.image = [self getImageFormStr:@"icon_tabbar_onsite"];
    item3.selectedImage = [self getImageFormStr:@"icon_tabbar_merchant_selected"];
    item3.image = [self getImageFormStr:@"icon_tabbar_merchant_normal"];
    item4.selectedImage = [self getImageFormStr:@"icon_tabbar_mine_selected"];
    item4.image = [self getImageFormStr:@"icon_tabbar_mine"];
    item5.selectedImage = [self getImageFormStr:@"icon_tabbar_misc_selected"];
    item5.image = [self getImageFormStr:@"icon_tabbar_misc"];
    
    //改变UITabBarItem字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : JGRGB(54, 185, 175)} forState:UIControlStateSelected];
}

- (UIImage *)getImageFormStr:(NSString *)imgStr {
    return [[UIImage imageNamed:imgStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
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
