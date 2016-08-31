//
//  AppDelegate.m
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/30.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import "AppDelegate.h"
#import "JGTabBarController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //设置经纬度
    _latitude = LATITUDE_DEFAULT;
    _longitude = LONGITUDE_DEFAULT;
    
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[JGTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    
    [self initAdvView];
    
    
    return YES;
}

- (void)initAdvView {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isExit = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (isExit) {
//        JGLog(@"存在");
        _advImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHight)];
        [_advImage setImage:[UIImage imageWithContentsOfFile:filePath]];
        [self.window addSubview:_advImage];
        [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:1];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //加载启动广告并保存到本地沙盒，因为保存的图片较大，每次运行都要保存，所以注掉了
            [self getLoadingImage];
        });
    }else{
//        JGLog(@"不存在");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getLoadingImage];
        });
    }  
}

//获取启动广告图片，采用后台推送时执行请求
-(void)getLoadingImage{
    //分辨率
    CGFloat scale_screen = [UIScreen mainScreen].scale;
//    JGLog(@"%.0f    %.0f",kDeviceWidth*scale_screen,kDeviceHight*scale_screen);
    int scaleW = (int)kDeviceWidth*scale_screen;
    int scaleH = (int)kDeviceHight*scale_screen;
    
    NSString *urlStr = [NSString stringWithFormat:APP_AD_URL,scaleW,@"%2A",scaleH];
    
    [[NetworkSingleton sharedManager] getAdvLoadingImage:nil url:urlStr successBlock:^(id responseBody){
//        JGLog(@"获取启动广告图片成功");
        NSMutableArray *dataArray = [responseBody objectForKey:@"data"];
//        JGLog(@"dataArray:%@",dataArray);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (dataArray.count>0) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dataArray[0] objectForKey:@"imageUrl"]]];
                UIImage *image = [UIImage imageWithData:data];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                
                NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];   // 保存文件的名称
                //    BOOL result = [UIImagePNGRepresentation() writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
//                JGLog(@"paths:%@    %@",paths,filePath);
                [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
                
            }
        });
        
    } failureBlock:^(NSString *error){
//        JGLog(@"获取启动广告图片失败：%@",error);
    }];
}

-(void)removeAdvImage{
    [UIView animateWithDuration:0.3f animations:^{
        _advImage.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        _advImage.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_advImage removeFromSuperview];
    }];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
