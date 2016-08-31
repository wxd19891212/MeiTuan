//
//  AppDelegate.h
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/30.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property(nonatomic, strong) UITabBarController *rootTabbarCtr;
@property(nonatomic, strong) UIImageView *advImage;
@end

