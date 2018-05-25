
#import "ResolveData.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#define APP_BASEURL @"http://www.polaxiong.com/"

@implementation ResolveData


+ (void)resolveDataWithUrlStr:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb
{
    //转成url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_BASEURL,urlStr]];
    //准备请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置method
    [request setHTTPMethod:method];
    if ([method isEqualToString:@"POST"]) {
        NSData *pragamData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:pragamData];
    }
    //建立连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (response == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"快去检查你的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return ;
        }
        
        if (connectionError) {
            if (connectionError.code == -1004) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"连接不上服务器" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }
            return ;
        }
        if (data == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"快去检查你的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return ;
        } else {
        id tempObj = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        //block调用
        rb(tempObj);
        }
    }];
}

+ (void)resolveDataWithUrlStr:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb failureBlock:(FailureBlock)fb
{
    //转成url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_BASEURL,urlStr]];
    //准备请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置method
    [request setHTTPMethod:method];
    if ([method isEqualToString:@"POST"]) {
        NSData *pragamData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:pragamData];
    }
    //建立连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            fb(connectionError);
            return;
        }
        if (data == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"快去检查你的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return ;
        } else {
            id tempObj = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];

            //block调用
            rb(tempObj);
        }
    }];
}

/***
 *是否现实hud
*****/
+ (void)resolveDataWithUrlStr:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb failureBlock:(FailureBlock)fb showHUD:(BOOL)showHud {
    
    if (showHud) {
        [MBProgressHUD showHUDAddedTo:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
    }
    //转成url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_BASEURL,urlStr]];
    //准备请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置method
    [request setHTTPMethod:method];
    if ([method isEqualToString:@"POST"]) {
        NSData *pragamData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:pragamData];
    }
    //建立连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [MBProgressHUD hideHUDForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
            fb(connectionError);
            return;
        }
        if (data == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"快去检查你的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [MBProgressHUD hideHUDForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
            return ;
        } else {
            [MBProgressHUD hideHUDForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
            id tempObj = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            
            
            //block调用
            rb(tempObj);
        }
    }];
}


+ (void)resolveDataForsynRequestWithUrlStr:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb
{
    //转成url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_BASEURL,urlStr]];
    //准备请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置method
    [request setHTTPMethod:method];
    if ([method isEqualToString:@"POST"]) {
        NSData *pragamData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:pragamData];
    }
    //建立连接
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"快去检查你的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    } else {
        id tempObj = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        //block调用
        rb(tempObj);
    }
}



//基础地址分享
+ (void)resolveDataWithUrlBaseStr:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb
{
    //转成url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]];
    //准备请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置method
    [request setHTTPMethod:method];
    if ([method isEqualToString:@"POST"]) {
        NSData *pragamData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:pragamData];
    }
    //建立连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            if (connectionError.code == -1004) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"连接不上服务器" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }
            return ;
        }
        if (data == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"快去检查你的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return ;
        } else {
            id tempObj = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            //block调用
            rb(tempObj);
        }
    }];
}

+ (void)resolveDataWithUrlStrGetUserID:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb failureBlock:(FailureBlock)fb {
    //转成url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_BASEURL,urlStr]];
    //准备请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置method
    [request setHTTPMethod:method];
    if ([method isEqualToString:@"POST"]) {
        NSData *pragamData = [postBody dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:pragamData];
    }
    //建立连接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            fb(connectionError);
            return;
        }
        if (data == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"快去检查你的网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return ;
        } else {

            NSString *tempStr = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
            
            NSArray *temArray = [tempStr componentsSeparatedByString:@"user_id=\""];
            NSString *tempStr2 = [temArray lastObject];
            NSArray *temArray2 = [tempStr2 componentsSeparatedByString:@"\""];
            NSString *tempStr3 = [temArray2 firstObject];
            
            rb(tempStr3);
        }
    }];
}


@end
