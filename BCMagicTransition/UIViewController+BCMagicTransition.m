//
//  UIViewController+BCMagicTransition.m
//  Demo
//
//  Created by Nikhil Nigade on 6/4/15.
//  Copyright (c) 2015 Boyce. All rights reserved.
//

#import <objc/runtime.h>
#import "BCMagicTransition.h"

#import "UIViewController+BCMagicTransition.h"

static char kPopTransit;
static char kPushTransit;
static char kInteractivePopTransition;

@implementation UIViewController (BCMagicTransition)

@dynamic popTransit;
@dynamic pushTransit;
@dynamic interactivePopTransition;


#pragma mark - Swizzled Methods

- (void)bc_viewDidAppear:(BOOL)animated {
    [self bc_viewDidAppear:animated];
    
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    if (self.popTransit) {
        self.navigationController.delegate = self;
    }
}

- (void)bc_viewWillDisappear:(BOOL)animated {
    [self bc_viewWillDisappear:animated];
    
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}


#pragma mark - Class Methods
+ (void)load {
    [super load];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method original, swizzled;
        
        //viewDidAppear:
        {
            original = class_getInstanceMethod(self, @selector(viewDidAppear:));
            swizzled = class_getInstanceMethod(self, @selector(bc_viewDidAppear:));
            method_exchangeImplementations(original, swizzled);
        }
        
        //viewWillDisappear:
        {
            original = class_getInstanceMethod(self, @selector(viewWillDisappear:));
            swizzled = class_getInstanceMethod(self, @selector(bc_viewWillDisappear:));
            method_exchangeImplementations(original, swizzled);
        }
        
    });
}


#pragma mark - Properties

- (UIPercentDrivenInteractiveTransition *)interactivePopTransition {
    return objc_getAssociatedObject(self, &kInteractivePopTransition);
}

- (void)setInteractivePopTransition:(UIPercentDrivenInteractiveTransition *)value {
    objc_setAssociatedObject(self, &kInteractivePopTransition, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BCMagicTransition *)popTransit {
    return objc_getAssociatedObject(self, &kPopTransit);
}

- (void)setPopTransit:(BCMagicTransition *)value {
    objc_setAssociatedObject(self, &kPopTransit, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BCMagicTransition *)pushTransit {
    return objc_getAssociatedObject(self, &kPushTransit);
}

- (void)setPushTransit:(BCMagicTransition *)value {
    objc_setAssociatedObject(self, &kPushTransit, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Instance methods

- (void)pushViewController:(UIViewController *)viewController
                  fromView:(UIView *)fromView
                    toView:(UIView *)toView
                  duration:(NSTimeInterval)duration
{
    [self pushViewController:viewController fromViews:@[fromView] toViews:@[toView] duration:duration];
}

- (void)pushViewController:(UIViewController *)viewController
                 fromViews:(NSArray *)fromViews
                   toViews:(NSArray *)toViews
                  duration:(NSTimeInterval)duration
{
    BCMagicTransition *magicPush = [BCMagicTransition new];
    magicPush.isMagic = YES;
    magicPush.isPush = YES;
    magicPush.duration = duration;
    magicPush.fromViews = fromViews;
    magicPush.toViews = toViews;
    self.pushTransit = magicPush;
    self.navigationController.delegate = self;
    
    BCMagicTransition *magicPop = [BCMagicTransition new];
    magicPop.isMagic = YES;
    magicPop.isPush = NO;
    magicPop.duration = duration;
    magicPop.fromViews = toViews;
    magicPop.toViews = fromViews;
    viewController.popTransit = magicPop;
    
    // add pop gesture to viewController
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:viewController action:@selector(edgePanGesture:)];
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [viewController.view addGestureRecognizer:edgePanGestureRecognizer];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - <UINavigationControllerDelegate>

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([viewController conformsToProtocol:NSProtocolFromString(@"BCMagicTransitionProtocol")]) {
        [(UIViewController *)viewController setPushTransit:nil];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    switch (operation) {
        case UINavigationControllerOperationPush: {
            if ([fromVC conformsToProtocol:NSProtocolFromString(@"BCMagicTransitionProtocol")] && fromVC.pushTransit) {
                return fromVC.pushTransit;
            } else {
                BCMagicTransition *normalPush = [BCMagicTransition new];
                normalPush.isMagic  = NO;
                normalPush.isPush   = YES;
                normalPush.duration = DEFAULT_TRANSITON_DURATION;
                normalPush.delay    = DEFAULT_TRANSITON_DELAY;
                normalPush.damping  = DEFAULT_TRANSITON_DAMPING;
                normalPush.velocity = DEFAULT_TRANSITON_VELOCITY;
                return normalPush;
            }
            break;
        }
        case UINavigationControllerOperationPop: {
            if ([fromVC conformsToProtocol:NSProtocolFromString(@"BCMagicTransitionProtocol")] && fromVC.popTransit) {
                return fromVC.popTransit;
            } else {
                BCMagicTransition *normalPop = [BCMagicTransition new];
                normalPop.isMagic  = NO;
                normalPop.isPush   = NO;
                normalPop.duration = DEFAULT_TRANSITON_DURATION;
                normalPop.delay    = DEFAULT_TRANSITON_DELAY;
                normalPop.damping  = DEFAULT_TRANSITON_DAMPING;
                normalPop.velocity = DEFAULT_TRANSITON_VELOCITY;
                return normalPop;
            }
            break;
        }
        default: {
            return nil;
        }
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    BCMagicTransition *magicTransition = animationController;
    if ([self conformsToProtocol:NSProtocolFromString(@"BCMagicTransitionProtocol")] && !magicTransition.isPush) {
        return self.interactivePopTransition;
    }
    
    return nil;
}


#pragma mark - pop gesture

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactivePopTransition = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.interactivePopTransition updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (progress > 0.3) {
                [self.interactivePopTransition finishInteractiveTransition];
            } else {
                [self.interactivePopTransition cancelInteractiveTransition];
            }
            self.interactivePopTransition = nil;
            break;
        }
        default: {
            break;
        }
    }
}

@end
