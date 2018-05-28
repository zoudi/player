//
//  AppDelegate.m
//  football
//
//  Created by masha on 2018/5/16.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import <AVOSCloud/AVOSCloud.h>
#import "WebViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AMapServices sharedServices].apiKey =@"b757beacf3e95054aa9b44be4b92c1c1";
    [AVOSCloud setApplicationId:@"4M63gU82yYNQTPoTfuy1QrpP-gzGzoHsz" clientKey:@"K807wIChVVoS5AnjNxKAbmSi"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
 
    AVQuery *query = [AVQuery queryWithClassName:@"WebURL"];
    [query getObjectInBackgroundWithId:@"5b07b367a22b9d0032495b8c" block:^(AVObject *object, NSError *error) {
        if (!error){
            if (object != nil && object != NULL && [object objectForKey:@"AppURL"]) {
                NSString *urlSrt = [object objectForKey:@"AppURL"];
                if ([urlSrt hasPrefix:@"http://"]||[urlSrt hasPrefix:@"https://"]) {
                    NSURL *url = [NSURL URLWithString:urlSrt];
                    WebViewController *VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
                    VC.url = url;
                    self.window.rootViewController = VC;
                }
            }
        }
        
    }];
    
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    // Override point for customization after application launch.
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
