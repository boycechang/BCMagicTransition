//
//  ThirdViewController.h
//  Demo
//
//  Created by Boyce on 4/8/15.
//  Copyright (c) 2015 Boyce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BCMagicTransition.h"

@interface ThirdViewController : UIViewController <BCMagicTransitionProtocol>

@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;

@end
