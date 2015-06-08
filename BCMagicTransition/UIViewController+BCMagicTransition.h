//
//  UIViewController+BCMagicTransition.h
//  Demo
//
//  Created by Nikhil Nigade on 6/4/15.
//  Copyright (c) 2015 Boyce. All rights reserved.
//

#import "BCMagicTransition.h"

// Conform to this protocol on a viewController which utilizes BCMagicTransition. ViewControllers which don't will not be affected.
@protocol BCMagicTransitionProtocol <NSObject>

@end

@interface UIViewController (BCMagicTransition) <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic, strong) BCMagicTransition *popTransit;
@property (nonatomic, strong) BCMagicTransition *pushTransit;

- (void)pushViewController:(UIViewController *)viewController
                  fromView:(UIView *)fromView
                    toView:(UIView *)toView
                  duration:(NSTimeInterval)duration;

- (void)pushViewController:(UIViewController *)viewController
                 fromViews:(NSArray *)fromViews
                   toViews:(NSArray *)toViews
                  duration:(NSTimeInterval)duration;

@end
