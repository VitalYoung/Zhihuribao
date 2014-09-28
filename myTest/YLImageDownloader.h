//
//  YLImageDownloader.h
//  myTest
//
//  Created by 朱洋 on 9/12/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol YLImageDownloaderDelegate;

@interface YLImageDownloader : NSObject{
@private
    __unsafe_unretained id<YLImageDownloaderDelegate> delegate;
}
@property (nonatomic, strong)NSString *purpose;
@property (nonatomic, strong)NSURLConnection *conn;
@property (nonatomic, strong)NSMutableData *activeDownload;
@property (nonatomic, copy)NSString *requestUrl;

@property (nonatomic, assign)id<YLImageDownloaderDelegate> delegate;

- (void)startDownloadWithUrl:(NSString*)url;

- (void)cancelDownload;
@end

@protocol YLImageDownloaderDelegate

- (void)downloader:(YLImageDownloader*)downloader completeWithData:(NSData*)data;
- (void)downloader:(YLImageDownloader *)downloader didFinishWithError:(NSString*)message;
@end
