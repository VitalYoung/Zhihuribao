//
//  YLReverseLocation.h
//  myTest
//
//  Created by Yang Zhu on 9/30/14.
//  Copyright (c) 2014 Yang Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^CompleteBlock)(CLLocation *location);
typedef void (^ErrorBlock)(NSString *error);
typedef void (^ReverseCompleteBlock)(NSString *address);
typedef void (^ReverseErrorBlock)(NSString *error);

@interface YLReverseLocation : NSObject<CLLocationManagerDelegate>

@property (strong ,nonatomic)CLLocation *curLocation;
@property (copy, nonatomic)NSString *address;
@property (copy, nonatomic)CompleteBlock completeBlock;
@property (copy, nonatomic)ErrorBlock errorBlock;
@property (copy, nonatomic)ReverseCompleteBlock reverseCompleteBlock;
@property (copy, nonatomic)ReverseErrorBlock reverseErrorBlock;

+ (YLReverseLocation *)sharedLocation;
/**
 *  更新用户的地理位置
 *
 *  @param comBlock 成功 返回经纬度
 *  @param errBlock 失败 返回错误信息
 */
- (void)updateLocationOnCompletion:(CompleteBlock)comBlock error:(ErrorBlock)errBlock;
/**
 *  获得用户的位置信息
 *
 *  @param location        用户的经纬度信息
 *  @param reverseComBlock 成功 返回位置信息
 *  @param reverseErrBlock 失败 返回错误信息
 */
- (void)reverseAddressFromLocation:(CLLocation *)location onCompletion:(ReverseCompleteBlock)reverseComBlock error:(ReverseErrorBlock)reverseErrBlock;


@end
