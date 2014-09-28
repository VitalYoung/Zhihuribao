//
//  YLFirstViewController.h
//  myTest
//
//  Created by 朱洋 on 9/11/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import "YLBaseViewController.h"
#define kDownloadLastestNewsUrl         @"http://news-at.zhihu.com/api/3/news/latest"
#define kDownloadBeforeNewsUrl          @"http://news.at.zhihu.com/api/3/news/before/%@"

@interface YLFirstViewController : YLBaseViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *storiesWebView;
@property (strong, nonatomic) IBOutlet UITableView *newsListTableView;
@property (strong, nonatomic) UIRefreshControl *refrshControl;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *titleSegment;

@end
