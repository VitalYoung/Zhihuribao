//
//  YLDownloader.m
//  myTest
//
//  Created by 朱洋 on 9/15/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import "YLDownloader.h"
#import "YLDownloaderManager.h"

@interface YLDownloader ()

- (void)clearData;

@end
@implementation YLDownloader
@synthesize purpose;
@synthesize request,conn,responseData;
@synthesize delegate,status;

#pragma mark - init method
- (id)init
{
    self = [super init];
    if (self != nil) {
        status = kDownloadWaiting;
    }
    return self;
}

#pragma mark - private methods
- (void)clearData
{
    self.request = nil;
    self.conn = nil;
    self.responseData = nil;
    self.purpose = nil;
}

#pragma mark - public methods
-(void)startDownloadWithRequest:(NSURLRequest *)req callback:(id<YLDownloaderDelegate>)receiver purpose:(NSString *)pur
{
    self.request = req;
    self.delegate = receiver;
    self.purpose = pur;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.responseData = [NSMutableData data];
    self.conn = [NSURLConnection connectionWithRequest:self.request delegate:self];
}
-(void)cancelDownload
{
    [self.conn cancel];
    [self clearData];
    self.status = kDownloadCanceled;
    [[YLDownloaderManager sharedYLDownloaderManager] reloadNetworkActivityIndicator];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
#pragma mark - NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(downloader:didFinishWithError:)]) {
        [self.delegate downloader:self didFinishWithError:[NSString stringWithFormat:@"%@",error]];
        self.status = kDownloadFailed;
        [self clearData];
        [[YLDownloaderManager sharedYLDownloaderManager] reloadNetworkActivityIndicator];
    }
    
}
#pragma mark - NSURLConnectionDataDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //TODO
    NSHTTPURLResponse * httpResponse;
	httpResponse = (NSHTTPURLResponse *) response;
	assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
	if ((httpResponse.statusCode / 100) != 2)
	{
        /**
         HTTP协议状态码表示的意思主要分为五类 ,大体是 :
         1×× 　　保留
         2×× 　　表示请求成功地接收                - Successful
         3×× 　　为完成请求客户需进一步细化请求      - Redirection
         4×× 　　客户错误                        - Client Error
         5×× 　　服务器错误                      - Server Error
         */
        
        [connection cancel];
		[self connection:connection didFailWithError:[NSError errorWithDomain:@"response error" code:httpResponse.statusCode userInfo:nil]];
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(downloader:completeWithData:)]) {
        [self.delegate downloader:self completeWithData:self.responseData];
        self.status = kDownloadSucceeded;
        [self clearData];
        [[YLDownloaderManager sharedYLDownloaderManager] reloadNetworkActivityIndicator];
    }
    
}
@end
