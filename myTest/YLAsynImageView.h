//
//  YLAsynImageView.h
//  myTest
//
//  Created by 朱洋 on 9/15/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLImageDownloader;

@interface YLAsynImageView : UIImageView

@property (nonatomic, strong)YLImageDownloader *aysnDownloader;
@property (nonatomic, copy)NSString *placeholdName;
@property (nonatomic, copy)NSString *cacheDir;

- (void)aysnLoadImageWithUrl:(NSString*)url placeHolder:(NSString*)placeHolder;
@end
