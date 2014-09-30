//
//  YLLocationViewController.m
//  myTest
//
//  Created by Yang Zhu on 9/29/14.
//  Copyright (c) 2014 Yang Zhu. All rights reserved.
//

#import "YLLocationViewController.h"
#import "YLReverseLocation.h"

@interface YLLocationViewController ()

@end

@implementation YLLocationViewController
@synthesize locationMV;
@synthesize addressTextField;

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
    self.navigationController.title = @"定位";
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(32.9349133234,118.7609190409);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1f, 0.1f);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    @try {
        [self.locationMV setRegion:region animated:YES];
    }
    @catch (NSException *exception) {
        
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:32.9349133234 longitude:118.7609190409];
    [[YLReverseLocation sharedLocation] reverseAddressFromLocation:location onCompletion:^(NSString *address) {
        self.addressTextField.text = address;
    } error:^(NSString *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
