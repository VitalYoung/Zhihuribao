//
//  YLLocationViewController.h
//  myTest
//
//  Created by Yang Zhu on 9/29/14.
//  Copyright (c) 2014 Yang Zhu. All rights reserved.
//

#import "YLBaseViewController.h"
#import <MapKit/MapKit.h>

@interface YLLocationViewController : YLBaseViewController
@property (strong, nonatomic) IBOutlet MKMapView *locationMV;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;

@end
