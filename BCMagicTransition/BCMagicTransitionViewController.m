//
//  BCMagicTransitionViewController.m
//  BCMagicTransitionViewController
//
//  Created by Xaiobo Zhang on 10/22/14.
//  Copyright (c) 2014 Xaiobo Zhang. All rights reserved.
//

#import "BCMagicTransitionViewController.h"

#define DEFAULT_TRANSITON_DURATION 0.3

@interface BCMagicTransitionViewController ()

@end

@implementation BCMagicTransitionViewController

#pragma mark UIViewController methods

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    if (self.popTransit) {
        self.navigationController.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(BCMagicTransitionViewController *)viewController fromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration{
    NSArray *fromViews = [NSArray arrayWithObject:fromView];
    NSArray *toViews = [NSArray arrayWithObject:toView];
    [self pushViewController:(BCMagicTransitionViewController *)viewController fromViews:fromViews toViews:toViews duration:duration];
}

- (void)pushViewController:(BCMagicTransitionViewController *)viewController fromViews:(NSArray *)fromViews toViews:(NSArray *)toViews duration:(NSTimeInterval)duration {
    BCMagicTransition *magicPush = [BCMagicTransition new];
    magicPush.isMagic = YES;
    magicPush.isPush = YES;
    magicPush.duration = duration;
    magicPush.fromViews = fromViews;
    magicPush.toViews = toViews;
    self.pushTransit = magicPush;
    self.navigationController.delegate = self;
    
    // Add pop gesture and animation to viewcontroller
    BCMagicTransitionViewController *transitVC = (BCMagicTransitionViewController *)viewController;
    
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanGestureRecognizer:)];
    popRecognizer.edges = UIRectEdgeLeft;
    [transitVC.view addGestureRecognizer:popRecognizer];
    
    BCMagicTransition *magicPop = [BCMagicTransition new];
    magicPop.isMagic = YES;
    magicPop.isPush = NO;
    magicPop.duration = duration;
    magicPop.fromViews = toViews;
    magicPop.toViews = fromViews;
    transitVC.popTransit = magicPop;
    
    [self.navigationController pushViewController:transitVC animated:YES];
}


#pragma mark UINavigationControllerDelegate methods
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[BCMagicTransitionViewController class]])
        [(BCMagicTransitionViewController *)viewController setPushTransit:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    switch (operation) {
        case UINavigationControllerOperationPush:
        {
            if ([fromVC isKindOfClass:[BCMagicTransitionViewController class]] && [(BCMagicTransitionViewController *)fromVC pushTransit]) {
                return [(BCMagicTransitionViewController *)fromVC pushTransit];
            } else {
                BCMagicTransition *normalPush = [BCMagicTransition new];
                normalPush.isMagic = NO;
                normalPush.isPush = YES;
                normalPush.duration = DEFAULT_TRANSITON_DURATION;
                return normalPush;
            }
        }
            break;
        case UINavigationControllerOperationPop:
        {
            if ([fromVC isKindOfClass:[BCMagicTransitionViewController class]] && [(BCMagicTransitionViewController *)fromVC popTransit]) {
                return [(BCMagicTransitionViewController *)fromVC popTransit];
            } else {
                BCMagicTransition *normalPop = [BCMagicTransition new];
                normalPop.isMagic = NO;
                normalPop.isPush = NO;
                normalPop.duration = DEFAULT_TRANSITON_DURATION;
                return normalPop;
            }
        }
            break;
        default:
            return nil;
            break;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([navigationController.topViewController isKindOfClass:[BCMagicTransitionViewController class]]) {
        BCMagicTransitionViewController *viewController = (BCMagicTransitionViewController *)navigationController.topViewController;
        return viewController.interactivePopTransition;
    } else {
        return nil;
    }
}

- (void)handleEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 0.99);
    progress = MIN(0.99, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        [self.interactivePopTransition updateInteractiveTransition:progress];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.4) {
            [self.interactivePopTransition finishInteractiveTransition];
        } else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}

@end
