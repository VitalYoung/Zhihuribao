//
//  YLImageDownloader.m
//  myTest
//
//  Created by 朱洋 on 9/12/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import "YLImageDownloader.h"

@implementation YLImageDownloader
@synthesize delegate;
@synthesize purpose,requestUrl;
@synthesize activeDownload, conn;

#pragma mark - methods
-(void)startDownloadWithUrl:(NSString *)url
{
    [self cancelDownload];
    self.requestUrl = url;
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                                                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f]
                                                                  delegate:self];
    self.conn = connection;
    if (self.conn != nil) {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.activeDownload = data;
    }
}
-(void)cancelDownload
{
    [self.conn cancel];
    self.conn = nil;
}
#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [delegate downloader:self didFinishWithError:[NSString stringWithFormat:@"%@",error]];
}
#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [delegate downloader:self completeWithData:self.activeDownload];
    self.activeDownload = nil;
}
@end
