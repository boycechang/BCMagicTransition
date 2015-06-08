//
//  SecondViewController.h
//  MagicTransition
//
//  Created by Boyce on 10/31/14.
//  Copyright (c) 2014 Boyce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BCMagicTransition.h"

@interface SecondViewController : UIViewController <BCMagicTransitionProtocol>

@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView1;
@property (nonatomic, weak) IBOutlet UIImageView *imageView2;

@end
