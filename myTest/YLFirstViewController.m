//
//  YLFirstViewController.m
//  myTest
//
//  Created by 朱洋 on 9/11/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import "YLFirstViewController.h"
#import "YLSYTableViewCell.h"
#import "YLWebViewController.h"
#import "YLDownloader.h"
#import "YLDownloaderManager.h"

static NSDate *nowDate ;

@interface YLFirstViewController ()
@property (strong, nonatomic)NSMutableArray *newsListArray;
@property (copy, nonatomic)NSString *urlStr;
@property (strong, nonatomic)NSDate *date;
@property (strong, nonatomic)UISwipeGestureRecognizer *swipeGestureLeft;
@property (strong, nonatomic)UISwipeGestureRecognizer *swipeGestureRight;
@end

@implementation YLFirstViewController
@synthesize newsListTableView;
@synthesize newsListArray;
@synthesize refrshControl;
@synthesize storiesWebView;
@synthesize urlStr,date;
@synthesize titleView,titleSegment;
@synthesize swipeGestureLeft = swipeGestureLeft_;
@synthesize swipeGestureRight = swipeGestureRight_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UIRefreshControl *)refrshControl
{
    if (refrshControl == nil) {
        refrshControl = [[UIRefreshControl alloc] init];
        [refrshControl addTarget:self action:@selector(refreshTrigger:) forControlEvents:UIControlEventValueChanged];
    }
    return refrshControl;
}
- (UISwipeGestureRecognizer*)swipeGestureLeft
{
    if (swipeGestureLeft_ == nil) {
        swipeGestureLeft_ = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        [swipeGestureLeft_ setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    return swipeGestureLeft_;
}
- (UISwipeGestureRecognizer*)swipeGestureRight
{
    if (swipeGestureRight_ == nil) {
        swipeGestureRight_ = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        [swipeGestureRight_ setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    return swipeGestureRight_;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"首页";
    [self.newsListTableView addSubview:self.refrshControl];
    [self.titleSegment setTitle:@"今日精选" forSegmentAtIndex:0];
    [self.titleSegment setTitle:@"历史--" forSegmentAtIndex:1];
    [self.titleSegment addTarget:self
                          action:@selector(segmentValueChanged:)
                forControlEvents:UIControlEventValueChanged];
    
    nowDate = [NSDate date];
    self.urlStr = kDownloadLastestNewsUrl;
    [self downloadLastestNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - methods
- (void)refreshTrigger:(UIRefreshControl *)rc
{
    if (rc.isRefreshing) {
        [self downloadLastestNews];
    }
}
- (void)segmentValueChanged:(UISegmentedControl *)sc
{
    if (self.titleSegment.selectedSegmentIndex == 0) {
        //今日精选
        [self.newsListTableView removeGestureRecognizer:self.swipeGestureLeft];
        [self.newsListTableView removeGestureRecognizer:self.swipeGestureRight];
        self.urlStr = kDownloadBeforeNewsUrl;
    }else if (self.titleSegment.selectedSegmentIndex == 1)
    {
        //历史
        
        [self.newsListTableView addGestureRecognizer:self.swipeGestureLeft];
        [self.newsListTableView addGestureRecognizer:self.swipeGestureRight];
    }
}
- (void)swipeGesture:(UISwipeGestureRecognizer*)gr
{
    NSDate *d = [self.date copy];
    if (gr.direction == UISwipeGestureRecognizerDirectionLeft) {
        //前一天
//        d = [NSDate dateWithTimeInterval:-8640.0f sinceDate:d];

        [self downloadNewsWithDate:d];
    }else if (gr.direction == UISwipeGestureRecognizerDirectionRight){
        //后一天
        NSLog(@"%f",[nowDate timeIntervalSinceDate:self.date]);
        if ([nowDate timeIntervalSinceDate:self.date]>86400.0f) {
            d = [NSDate dateWithTimeInterval:172800.0f sinceDate:d];
            [self downloadNewsWithDate:d];
        }
    }
}
- (void)downloadLastestNews
{
//    [[YLDownloaderManager sharedYLDownloaderManager] requestDataByGetWithURLString:kDownloadLastestNewsUrl
//                                                                          delegate:self
//                                                                           purpose:kDownloadLastestNewsUrl];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:30.0f];
    [self.storiesWebView loadRequest:request];
    self.storiesWebView.delegate = self;
}
- (void)downloadNewsWithDate:(NSDate *)d
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormat stringFromDate:d];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kDownloadBeforeNewsUrl,dateString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:30.0f];
    [self.storiesWebView loadRequest:request];
}
- (void)parseJSONData:(NSData *)rd
{
    self.newsListArray = [NSMutableArray array];
    NSError *error = nil;
    id rootCon= [NSJSONSerialization JSONObjectWithData:rd
                                                options:NSJSONReadingAllowFragments
                                                  error:&error];
    if (rootCon != nil && error == nil) {
        NSDictionary *rootDic = (NSDictionary*)rootCon;
        NSString *dateStr = [rootDic objectForKey:@"date"];
        if ([dateStr isKindOfClass:[NSNumber class]]) {
            dateStr = [NSString stringWithFormat:@"%@",date];
        }
        NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
        [dateF setDateFormat:@"yyyyMMdd"];
        self.date = [dateF dateFromString:dateStr];
        
        NSArray *topStoriesArray = [rootDic objectForKey:@"top_stories"];
        for(NSDictionary *tmpDic in topStoriesArray)
        {
            NSMutableDictionary *tDic = [NSMutableDictionary dictionary];
            NSString *storyId = [tmpDic objectForKey:@"id"];
            if ([storyId isKindOfClass:[NSNumber class]]) {
                storyId = [NSString stringWithFormat:@"%@",storyId];
            }
            [tDic setObject:storyId forKey:@"id"];
            NSMutableArray *imagesArray = [NSMutableArray array];
            NSArray *rootArray = [tmpDic objectForKey:@"images"];
            for(NSString *image in rootArray)
            {
                [imagesArray addObject:image];
            }
            [tDic setObject:imagesArray forKey:@"images"];
            NSString *shareUrl = [tmpDic objectForKey:@"share_url"];
            [tDic setObject:shareUrl forKey:@"share_url"];
            NSString *title = [tmpDic objectForKey:@"title"];
            [tDic setObject:title forKey:@"title"];
            
            [self.newsListArray addObject:tDic];
        }
        
        NSArray *storiesArray = [rootDic objectForKey:@"stories"];
        for(NSDictionary *tmpDic in storiesArray)
        {
            NSMutableDictionary *tDic = [NSMutableDictionary dictionary];
            NSString *storyId = [tmpDic objectForKey:@"id"];
            if ([storyId isKindOfClass:[NSNumber class]]) {
                storyId = [NSString stringWithFormat:@"%@",storyId];
            }
            [tDic setObject:storyId forKey:@"id"];
            NSMutableArray *imagesArray = [NSMutableArray array];
            NSArray *rootArray = [tmpDic objectForKey:@"images"];
            for(NSString *image in rootArray)
            {
                [imagesArray addObject:image];
            }
            [tDic setObject:imagesArray forKey:@"images"];
            NSString *shareUrl = [tmpDic objectForKey:@"share_url"];
            [tDic setObject:shareUrl forKey:@"share_url"];
            NSString *title = [tmpDic objectForKey:@"title"];
            [tDic setObject:title forKey:@"title"];
            
            [self.newsListArray addObject:tDic];
        }
        
        
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SYTableViewCellIdentifier";
    YLSYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"YLSYTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    cell.titleLabel.text = [self.newsListArray[indexPath.row] objectForKey:@"title"];
    NSArray *imageUrls = [self.newsListArray[indexPath.row] objectForKey:@"images"];
    NSString *imageUrl = nil;
    if (imageUrls.count>0) {
        imageUrl = [imageUrls objectAtIndex:0];
    }
    
    [cell.iconImageView aysnLoadImageWithUrl:imageUrl placeHolder:@"default"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.titleView.bounds.size.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.titleView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YLWebViewController *wbvc = [[YLWebViewController alloc] init];
    wbvc.url = [self.newsListArray[indexPath.row] objectForKey:@"share_url"];
    [self.navigationController pushViewController:wbvc animated:YES];
}
//#pragma mark - YLDownloaderDelegate
//- (void)downloader:(YLDownloader*)downloader completeWithData:(NSData*)data
//{
//    [self.refrshControl endRefreshing];
//    
//    if ([downloader.purpose isEqualToString:kDownloadLastestNewsUrl]) {
//        [self parseJSONData:data];
//    }
//}
//- (void)downloader:(YLDownloader*)downloader didFinishWithError:(NSString*)message
//{
//    [self.refrshControl endRefreshing];
//    NSLog(@"%@",message);
//}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.refrshControl endRefreshing];
    NSString *script = @"document.getElementsByTagName(\"body\")[0].innerText ";
    NSString *resultString = [webView stringByEvaluatingJavaScriptFromString:script];
    NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    [self parseJSONData:data];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMdd"];
    NSString *dateStr = [dateFormat stringFromDate:self.date];
    [self.titleSegment setTitle:[NSString stringWithFormat:@"历史%@",dateStr] forSegmentAtIndex:1];
    [self.newsListTableView reloadData];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.refrshControl endRefreshing];
    NSLog(@"%@",error);
}

@end
