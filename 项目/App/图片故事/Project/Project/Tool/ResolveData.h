

#import <Foundation/Foundation.h>

#define RefreshNum 10.0

typedef void(^ResolveBlock)(id obj);
typedef void(^FailureBlock)(id obj);

@interface ResolveData : NSObject

#warning 原网络请求有加密逻辑已删除，用基础网络封装做了替换

+ (void)resolveDataWithUrlStr:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb;

+ (void)resolveDataForsynRequestWithUrlStr:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb;

+ (void)resolveDataWithUrlStr:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb failureBlock:(FailureBlock)fb;



+ (void)resolveDataWithUrlStr:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb failureBlock:(FailureBlock)fb showHUD:(BOOL)showHud;

+ (void)resolveDataWithUrlBaseStr:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb;


//获取id
+ (void)resolveDataWithUrlStrGetUserID:(NSString *)urlStr setHTTPMethod:(NSString *)method postBody:(NSString *)postBody resolveBlock:(ResolveBlock)rb failureBlock:(FailureBlock)fb;

@end
