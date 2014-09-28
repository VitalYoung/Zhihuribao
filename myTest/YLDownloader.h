//
//  YLDownloader.h
//  myTest
//
//  Created by 朱洋 on 9/15/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    kDownloadWaiting    = 0,
    kDownloading        = 1,
    kDownloadSucceeded  = 2,
    kDownloadFailed     = 3,
    kDownloadCanceled   = 4
}DownloaderStatus;

@protocol YLDownloaderDelegate;

@interface YLDownloader : NSObject
@property (nonatomic, copy)NSString *purpose;
@property (nonatomic, strong)NSURLRequest *request;
@property (nonatomic, strong)NSURLConnection *conn;
@property (nonatomic, strong)NSMutableData *responseData;
@property (nonatomic, assign)DownloaderStatus status;
@property (nonatomic, assign)id<YLDownloaderDelegate> delegate;

- (void)startDownloadWithRequest:(NSURLRequest *)req callback:(id<YLDownloaderDelegate>)receiver purpose:(NSString *)pur;
- (void)cancelDownload;
@end
@protocol YLDownloaderDelegate <NSObject>

- (void)downloader:(YLDownloader*)downloader completeWithData:(NSData*)data;
- (void)downloader:(YLDownloader*)downloader didFinishWithError:(NSString*)message;

@end