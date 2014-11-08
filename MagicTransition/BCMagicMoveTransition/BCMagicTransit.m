//
//  BCMagicTransit.m
//  BCMagicTransit
//
//  Created by Xaiobo Zhang on 10/21/14.
//  Copyright (c) 2014 Xaiobo Zhang. All rights reserved.
//

#import "BCMagicTransit.h"

@interface BCMagicTransit ()

@end

@implementation BCMagicTransit

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    if (self.isMagic) {
        [self ftAnimationFromViewController:fromViewController toViewController:toViewController containerView:containerView duration:self.duration transitionContext:transitionContext];
    } else {
        [self defaultAnimationFromViewController:fromViewController toViewController:toViewController containerView:containerView duration:self.duration transitionContext:transitionContext];
    }
}

#pragma mark - private

- (void)defaultAnimationFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController containerView:(UIView *)containerView duration:(NSTimeInterval)duration transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    float deviation = (self.isPush)?1.0f:-1.0f;
    
    CGRect newFrame = toViewController.view.frame;
    newFrame.origin.x += newFrame.size.width*deviation;
    toViewController.view.frame = newFrame;
    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromViewController.view];
    
    [UIView animateWithDuration:duration animations:^{
        
        CGRect animationFrame = toViewController.view.frame;
        animationFrame.origin.x -= animationFrame.size.width*deviation;
        toViewController.view.frame = animationFrame;
        
        animationFrame = fromViewController.view.frame;
        animationFrame.origin.x -= animationFrame.size.width*deviation;
        fromViewController.view.frame = animationFrame;
        
    } completion:^(BOOL finished) {
        [fromViewController.view removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

- (void)ftAnimationFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController containerView:(UIView *)containerView duration:(NSTimeInterval)duration transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    NSMutableArray *fromViewSnapshotArray = [[NSMutableArray alloc] init];
    for (UIView *fromView in self.fromViews) {
        UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
        fromViewSnapshot.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
        fromView.hidden = YES;
        [fromViewSnapshotArray addObject:fromViewSnapshot];
    }
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    
    for (UIView *toView in self.toViews) {
        toView.hidden = YES;
    }
    
    [containerView addSubview:toViewController.view];
    
    for (NSUInteger i = [fromViewSnapshotArray count]; i > 0; i--) {
        [containerView addSubview:[fromViewSnapshotArray objectAtIndex:i-1]];
    }

    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        toViewController.view.alpha = 1.0;
        
        for (NSUInteger i = 0; i < [self.fromViews count]; i++) {
            UIView *toView = [self.toViews objectAtIndex:i];
            UIView *fromViewSnapshot = [fromViewSnapshotArray objectAtIndex:i];
            CGRect frame = [containerView convertRect:toView.frame fromView:toView.superview];
            fromViewSnapshot.frame = frame;
        }
        
        
    } completion:^(BOOL finished) {
        
        for (NSUInteger i = 0; i < [self.fromViews count]; i++) {
            UIView *toView = [self.toViews objectAtIndex:i];
            UIView *fromView = [self.fromViews objectAtIndex:i];
            UIView *fromViewSnapshot = [fromViewSnapshotArray objectAtIndex:i];
            toView.hidden = NO;
            fromView.hidden = NO;
            [fromViewSnapshot removeFromSuperview];
        }
    
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

@end
