//
//  YLDownloaderManager.m
//  myTest
//
//  Created by 朱洋 on 9/15/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import "YLDownloaderManager.h"
#import "YLDownloader.h"

@interface YLDownloaderManager ()
- (YLDownloader *)reuseDownloaderWithDelegate:(id<YLDownloaderDelegate>)receiver purpose:(NSString*)pur;

- (void)requestDataWithURLRequest:(NSURLRequest*)request delegate:(id<YLDownloaderDelegate>)receiver purpose:(NSString*)pur;

@end
@implementation YLDownloaderManager
-(id)init
{
    self = [super init];
    if (self != nil) {
        self.downloaders = [NSMutableArray array];
    }
    return self;
}
#pragma mark - private methods
-(YLDownloader *)reuseDownloaderWithDelegate:(id<YLDownloaderDelegate>)receiver purpose:(NSString *)pur
{
    [self cancelDownloaderWithDelegate:receiver purpose:pur];
    
    YLDownloader *downloader = nil;
    for(YLDownloader *down in self.downloaders)
    {
        if (down.status == kDownloadCanceled || down.status == kDownloadFailed || down.status == kDownloadSucceeded ) {
            downloader = down;
            break;
        }
    }
    if (downloader == nil) {
        downloader = [[YLDownloader alloc] init];

        [self.downloaders addObject:downloader];
    }
    downloader.status = kDownloadWaiting;
    downloader.delegate = receiver;
    downloader.purpose = pur;
    return downloader;
}
-(void)requestDataWithURLRequest:(NSURLRequest *)request delegate:(id<YLDownloaderDelegate>)receiver purpose:(NSString *)pur
{
    if (receiver != nil && pur != nil) {
        YLDownloader *downloader = [self reuseDownloaderWithDelegate:receiver purpose:pur];
        [downloader startDownloadWithRequest:request callback:receiver purpose:pur];
    }
}
#pragma mark - public methods
+(YLDownloaderManager *)sharedYLDownloaderManager
{
    static YLDownloaderManager *sharedManager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^(void){
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

-(void)removeUnuseDownloaders
{
    NSInteger index = 0;
    NSMutableIndexSet *unuseSet = [NSMutableIndexSet indexSet];
    for(YLDownloader *downloader in self.downloaders)
    {
        if (downloader.status != kDownloading) {
            [unuseSet addIndex:index];
        }
        index++;
    }
    [self.downloaders removeObjectsAtIndexes:unuseSet];
}

- (void)reloadNetworkActivityIndicator
{
    BOOL isDownloading = NO;
    for(YLDownloader *downloader in self.downloaders)
    {
        if (downloader.status == kDownloading) {
            isDownloading = YES;
            break;
        }
    }
    if (isDownloading) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

-(void)cancelDownloaderWithDelegate:(id)receiver purpose:(NSString *)purpose
{
    if (receiver == nil && purpose == nil) {
        //cancel all downloaders
        for(YLDownloader *downloader in self.downloaders)
        {
            if (downloader.status == kDownloading) {
                [downloader cancelDownload];
            }
        }
    }else if(receiver != nil && purpose == nil)
    {
        //cancel the downloaders which delegate is 'receiver'
        for(YLDownloader *downloader in self.downloaders)
        {
            if (downloader.status == kDownloading && downloader.delegate == receiver) {
                [downloader cancelDownload];
            }
        }
    }else if (receiver == nil && purpose != nil)
    {
        //cancel the downloads which purpose is 'purpose'
        for(YLDownloader *downloader in self.downloaders)
        {
            if (downloader.status == kDownloading && [downloader.purpose isEqualToString:purpose]) {
                [downloader cancelDownload];
            }
        }
    }else
    {
        //cancel the downloads which delegate is 'receiver' and purpose is 'purpose'
        for(YLDownloader *downloader in self.downloaders)
        {
            if (downloader.status == kDownloading && downloader.delegate == receiver && [downloader.purpose isEqualToString:purpose]) {
                [downloader cancelDownload];
            }
        }
    }
}

-(void)requestDataByGetWithURLString:(NSString *)urlStr delegate:(id)receiver purpose:(NSString *)purpose
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:30.0f];
    [self requestDataWithURLRequest:request
                           delegate:receiver
                            purpose:purpose];
}

@end
