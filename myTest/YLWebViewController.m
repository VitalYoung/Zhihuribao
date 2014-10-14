//
//  YLWebViewController.m
//  myTest
//
//  Created by 朱洋 on 9/12/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import "YLWebViewController.h"

@interface YLWebViewController ()

@end

@implementation YLWebViewController
@synthesize url;
@synthesize scrollView;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.contentSize = CGSizeMake(320.0f, 568.0f);
    
    NSURL *shareUrl = [NSURL URLWithString:self.url];
    NSURLRequest *requst = [NSURLRequest requestWithURL:shareUrl];
    [self.webView loadRequest:requst];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    NSString *scriptRemoveBanner = @"document.getElementsByClassName('download-banner-v2')[0].remove()";
    NSString *scriptRemoveRecommand = @"document.getElementsByClassName('bottom-recommend')[0].remove()";
    NSString *scriptRemoveDownload = @"document.getElementsByClassName('new-download-banner')[0].remove()";
    
    [wv stringByEvaluatingJavaScriptFromString:scriptRemoveBanner];
    [wv stringByEvaluatingJavaScriptFromString:scriptRemoveRecommand];
    [wv stringByEvaluatingJavaScriptFromString:scriptRemoveDownload];
}
@end
