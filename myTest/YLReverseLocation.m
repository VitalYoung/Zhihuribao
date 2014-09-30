//
//  YLReverseLocation.m
//  myTest
//
//  Created by Yang Zhu on 9/30/14.
//  Copyright (c) 2014 Yang Zhu. All rights reserved.
//

#import "YLReverseLocation.h"
@interface YLReverseLocation()

@property (strong, nonatomic)CLLocationManager *manager;

@end
@implementation YLReverseLocation
@synthesize curLocation;
@synthesize address;
@synthesize completeBlock,errorBlock;
@synthesize reverseCompleteBlock,reverseErrorBlock;
@synthesize manager = manager_;

- (id)init
{
    self = [super init];
    if (self != nil) {
        manager_ = [[CLLocationManager alloc] init];
        manager_.delegate = self;
        manager_.desiredAccuracy = kCLLocationAccuracyBest;
        manager_.distanceFilter = 200.0f;
    }
    return self;
}
+(YLReverseLocation *)sharedLocation
{
    static YLReverseLocation *location = nil;
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^(void){
        location = [[YLReverseLocation alloc] init];
    });
    
    return location;
}

-(void)updateLocationOnCompletion:(CompleteBlock)comBlock error:(ErrorBlock)errBlock
{
    self.completeBlock = comBlock;
    self.errorBlock = errBlock;
    if ([CLLocationManager locationServicesEnabled]&&([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized)) {
        //手机位置服务可用，并且用户没有拒绝app访问地理位置信息
        [manager_ startUpdatingLocation];
    }else
    {
        self.errorBlock(@"未打开定位服务");
    }
}

-(void)reverseAddressFromLocation:(CLLocation *)location onCompletion:(ReverseCompleteBlock)reverseComBlock error:(ReverseErrorBlock)reverseErrBlock
{
    self.reverseCompleteBlock = reverseComBlock;
    self.reverseErrorBlock = reverseErrBlock;
    
    CLGeocoder *geoceder = [[CLGeocoder alloc] init];
    [geoceder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil) {
            for(CLPlacemark *placemark in placemarks)
            {
                self.address = [NSString stringWithFormat:@"%@",[placemark.addressDictionary objectForKey:@"Name"]];
                self.reverseCompleteBlock(self.address);
            }
            
        }else
        {
            self.reverseErrorBlock(@"地址解析错误");
        }
    }];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    [manager_ stopUpdatingLocation];
    self.curLocation = newLocation;
    self.completeBlock(newLocation);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [manager_ stopUpdatingLocation];
    self.errorBlock([NSString stringWithFormat:@"%@",error]);
}
@end
