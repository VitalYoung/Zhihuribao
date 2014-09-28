//
//  YLWebViewController.h
//  myTest
//
//  Created by 朱洋 on 9/12/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import "YLBaseViewController.h"

@interface YLWebViewController : YLBaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic)NSString *url;
@end
