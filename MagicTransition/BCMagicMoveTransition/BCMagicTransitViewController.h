//
//  BCMagicTransitViewController.h
//  BCMagicTransit
//
//  Created by Xaiobo Zhang on 10/22/14.
//  Copyright (c) 2014 Xaiobo Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCMagicTransit.h"

@interface BCMagicTransitViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic, strong) BCMagicTransit *popTransit;
@property (nonatomic, strong) BCMagicTransit *pushTransit;

- (void)pushViewController:(BCMagicTransitViewController *)viewController fromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration;

- (void)pushViewController:(BCMagicTransitViewController *)viewController fromViews:(NSArray *)fromViews toViews:(NSArray *)toViews duration:(NSTimeInterval)duration;

@end
