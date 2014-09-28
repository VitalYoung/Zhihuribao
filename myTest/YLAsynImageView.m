//
//  YLAsynImageView.m
//  myTest
//
//  Created by 朱洋 on 9/15/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import "YLAsynImageView.h"
#import "YLImageDownloader.h"

@interface YLAsynImageView ()<YLImageDownloaderDelegate>

- (NSString *)getImageDirectory;
- (BOOL)isImageExistWithName:(NSString *)imageName;
@end

@implementation YLAsynImageView
@synthesize aysnDownloader = aysnDownloader_;
@synthesize placeholdName;
@synthesize cacheDir;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - Private methods
- (BOOL)isImageExistWithName:(NSString*)placeHolder
{
    if (nil != [UIImage imageNamed:placeHolder]) {
        return YES;
    }
    return NO;
}

- (NSString *)getImageDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths lastObject];
    return [dir stringByAppendingPathComponent:self.cacheDir];
}
#pragma mark - Public methods
-(void)aysnLoadImageWithUrl:(NSString *)url placeHolder:(NSString *)placeHolder
{
    if (nil != aysnDownloader_) {
        [aysnDownloader_ cancelDownload];
        aysnDownloader_.delegate = nil;
        aysnDownloader_ = nil;
    }
    self.placeholdName = placeHolder;
    //显示默认图片
    if (nil == url || [url isEqualToString:@""]) {
        if ([self isImageExistWithName:placeHolder]) {
            UIImage *img = [UIImage imageNamed:placeHolder];
            self.image = img;
        }
        return;
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [url componentsSeparatedByString:@"/"];
    NSString *imageName = [array lastObject];
    
    NSString *imagePath = [[self getImageDirectory] stringByAppendingPathComponent:imageName];
    
    BOOL isDir,valid;
    valid = [manager fileExistsAtPath:imagePath isDirectory:&isDir];
    if (valid && !isDir) {
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        self.image = img;
    }
    else
    {
        if ([self isImageExistWithName:placeHolder]) {
            UIImage *img = [UIImage imageNamed:placeHolder];
            self.image = img;
        }
        YLImageDownloader *downloader = [[YLImageDownloader alloc] init];
        downloader.purpose = imagePath;
        downloader.delegate = self;
        self.aysnDownloader = downloader;
        
        [self.aysnDownloader startDownloadWithUrl:url];
    }
}
#pragma mark - YLImageDownloaderDelegate
- (void)downloader:(YLImageDownloader*)downloader completeWithData:(NSData*)data
{
    UIImage *img = [UIImage imageWithData:data];
    if (nil == img) {
        [self downloader:downloader completeWithData:nil];
        return;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:[self getImageDirectory]]) {
        [manager createDirectoryAtPath:[self getImageDirectory]
           withIntermediateDirectories:NO
                            attributes:nil
                                 error:nil];
    }
    if ([data writeToFile:downloader.purpose atomically:NO]) {
        self.image = img;
    }
}
- (void)downloader:(YLImageDownloader *)downloader didFinishWithError:(NSString*)message
{
    if ([self isImageExistWithName:self.placeholdName]) {
        UIImage *img = [UIImage imageNamed:self.placeholdName];
        self.image = img;
    }
}
@end





















