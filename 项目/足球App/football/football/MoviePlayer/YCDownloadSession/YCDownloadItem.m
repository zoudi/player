//
//  YCDownloadItem.m
//  YCDownloadSession
//
//  Created by wz on 17/7/28.
//  Copyright © 2017年 onezen.cc. All rights reserved.
//

#import "YCDownloadItem.h"
#import <objc/runtime.h>

@implementation YCDownloadItem

#pragma mark - YCDownloadSessionDelegate
- (void)downloadProgress:(YCDownloadTask *)task totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    self.downloadedSize = totalBytesWritten;
    if ([self.delegate respondsToSelector:@selector(downloadItem:downloadedSize:totalSize:)]) {
        [self.delegate downloadItem:self downloadedSize:totalBytesWritten totalSize:totalBytesExpectedToWrite];
    }
}
- (void)downloadFailed:(YCDownloadTask *)task {
    self.downloadStatus = YCDownloadStatusFailed;
    [self saveDownloadStatusNoti];
}
- (void)downloadFinished:(YCDownloadTask *)task {
    self.downloadStatus = YCDownloadStatusFinished;
    [self saveDownloadStatusNoti];
}
- (void)downloadCreated:(YCDownloadTask *)task {
    self.downloadStatus = YCDownloadStatusDownloading;
    if(task.fileSize > 0){
        self.fileSize = task.fileSize;
    }
    _saveName = task.saveName;
    [self saveDownloadStatusNoti];
}

- (void)downloadPaused:(YCDownloadTask *)task {
    [self saveDownloadStatusNoti];
}


#pragma mark - public
- (void)setDownloadStatus:(YCDownloadStatus)downloadStatus {
    _downloadStatus = downloadStatus;
    if ([self.delegate respondsToSelector:@selector(downloadItemStatusChanged:)]) {
        [self.delegate downloadItemStatusChanged:self];
    }
}

- (NSString *)savePath {
    return [YCDownloadTask savePathWithSaveName:self.saveName];
}



#pragma mark - private

- (void)saveDownloadStatusNoti {
    [[NSNotificationCenter defaultCenter] postNotificationName:kYCDownloadSessionSaveDownloadStatus object:nil];
}


///  解档
- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        
        unsigned int count = 0;
        
        Ivar *ivars = class_copyIvarList([self class], &count);
        
        for (NSInteger i=0; i<count; i++) {
            
            Ivar ivar = ivars[i];
            NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(ivar)];
            if([name isEqualToString:@"delegate"]) continue;
            id value = [coder decodeObjectForKey:name];
            if(value) [self setValue:value forKey:name];
        }
        
        free(ivars);
    }
    return self;
}

///  归档
- (void)encodeWithCoder:(NSCoder *)coder
{
    
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (NSInteger i=0; i<count; i++) {
        
        Ivar ivar = ivars[i];
        NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(ivar)];
        if([name isEqualToString:@"delegate"]) continue;
        id value = [self valueForKey:name];
        if(value) [coder encodeObject:value forKey:name];
    }
    
    free(ivars);
}

@end
