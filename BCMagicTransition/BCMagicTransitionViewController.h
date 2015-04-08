//
//  BCMagicTransitionViewController.h
//  BCMagicTransitionViewController
//
//  Created by Xaiobo Zhang on 10/22/14.
//  Copyright (c) 2014 Xaiobo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCMagicTransition.h"

@interface BCMagicTransitionViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic, strong) BCMagicTransition *popTransit;
@property (nonatomic, strong) BCMagicTransition *pushTransit;

- (void)pushViewController:(BCMagicTransitionViewController *)viewController fromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration;

- (void)pushViewController:(BCMagicTransitionViewController *)viewController fromViews:(NSArray *)fromViews toViews:(NSArray *)toViews duration:(NSTimeInterval)duration;

@end
