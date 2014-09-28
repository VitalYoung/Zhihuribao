//
//  YLSYTableViewCell.h
//  myTest
//
//  Created by 朱洋 on 9/12/14.
//  Copyright (c) 2014 朱洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLAsynImageView.h"

@interface YLSYTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet YLAsynImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
