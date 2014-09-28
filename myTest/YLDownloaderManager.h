//
//  YLDownloaderManager.h
//  myTest
//
//  Created by 朱洋 on 9/15/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDownloaderManager : NSObject

@property (nonatomic, strong)NSMutableArray *downloaders;

+(YLDownloaderManager*)sharedYLDownloaderManager;

- (void)removeUnuseDownloaders;

- (void)reloadNetworkActivityIndicator;

- (void)cancelDownloaderWithDelegate:(id)receiver
                             purpose:(NSString *)purpose;

- (void)requestDataByGetWithURLString:(NSString *)urlStr
                             delegate:(id)receiver
                              purpose:(NSString *)purpose;
@end
