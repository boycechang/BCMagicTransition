//
//  BCInteractiveTransition.m
//  Demo
//
//  Created by Boyce Chang on 7/6/15.
//  Copyright (c) 2015 Boyce Chang. All rights reserved.
//

#import "BCInteractiveTransition.h"

@interface BCInteractiveTransition()

@property (nonatomic, assign) BCInteractiveTransitionType type;

@property (nonatomic, weak) UIViewController *presentingVC;
@property (nonatomic, strong) UIGestureRecognizer *gesture;

@end


@implementation BCInteractiveTransition

+ (BCInteractiveTransition *)transitionWithType:(BCInteractiveTransitionType)type {
    BCInteractiveTransition *transition = [self new];
    transition.type = type;
    
    switch (type) {
        case BCInteractiveTransitionTypeEdgePan:
        {
            UIScreenEdgePanGestureRecognizer *edgeGesture = [UIScreenEdgePanGestureRecognizer new];
            edgeGesture.edges = UIRectEdgeLeft;
            transition.gesture = edgeGesture;
        }
            break;
        default:
            break;
    }
    
    [transition.gesture addTarget:transition action:@selector(handleGestureRecognizer:)];
    transition.completionSpeed = 0.999;
    
    return transition;
}

- (void)attachToViewController:(UIViewController *)viewController {
    _presentingVC = viewController;
    [viewController.view addGestureRecognizer:self.gesture];
}


#pragma mark - private method

- (void)handleGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat progress;
    
    switch (self.type) {
        case BCInteractiveTransitionTypeEdgePan:
            progress = [gestureRecognizer translationInView:gestureRecognizer.view.superview].x / self.presentingVC.view.bounds.size.width;
            break;
        default:
            break;
    }
    
    progress = fminf(fmaxf(progress, 0.0), 1.0);
    [self handleProgress:progress];
}

- (void)handleProgress:(float)progress {
    switch (self.gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.interacting = YES;
            [self.presentingVC.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            // Gesture over. Check if the transition should happen or not
            self.interacting = NO;
            
            if (progress <= 0.4 || self.gesture.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

@end
