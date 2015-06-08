//
//  UIViewController+BCMagicTransition.m
//  Demo
//
//  Created by Nikhil Nigade on 6/4/15.
//  Copyright (c) 2015 Boyce. All rights reserved.
//

#import "UIViewController+BCMagicTransition.h"
#import <objc/runtime.h>

static char kPopTransit;
static char kPushTransit;
static char kInteractivePopTransition;

#define DEFAULT_TRANSITON_DURATION 0.3
@implementation UIViewController (BCMagicTransition)

@dynamic popTransit;
@dynamic pushTransit;
@dynamic interactivePopTransition;

#pragma mark - Swizzled Methods

- (void)dz_viewDidAppear:(BOOL)animated
{
    
    [self dz_viewDidAppear:animated];
    NSLog(@"%@ dz_viewDidAppear:", NSStringFromClass([self class]));
    // Set outself as the navigation controller's delegate so we're asked for a transitioning object
    if (self.popTransit)
    {
        self.navigationController.delegate = self;
    }
    
}

- (void)dz_viewWillDisappear:(BOOL)animated {
    
    [self dz_viewWillDisappear:animated];
    NSLog(@"%@ dz_viewWillDisappear:", NSStringFromClass([self class]));
    // Stop being the navigation controller's delegate
    if (self.navigationController.delegate == self)
    {
        self.navigationController.delegate = nil;
    }
}


#pragma mark - Class Methods
+ (void)load
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method original, swizzled;
        
        //viewDidAppear:
        {
            original = class_getInstanceMethod(self, @selector(viewDidAppear:));
            swizzled = class_getInstanceMethod(self, @selector(dz_viewDidAppear:));
            method_exchangeImplementations(original, swizzled);
        }
        
        //viewWillDisappear:
        {
            original = class_getInstanceMethod(self, @selector(viewWillDisappear:));
            swizzled = class_getInstanceMethod(self, @selector(dz_viewWillDisappear:));
            method_exchangeImplementations(original, swizzled);
        }
        
    });
    
}

#pragma mark - Properties

- (UIPercentDrivenInteractiveTransition *)interactivePopTransition
{
    return objc_getAssociatedObject(self, &kInteractivePopTransition);
}

- (void)setInteractivePopTransition:(UIPercentDrivenInteractiveTransition *)value
{
    objc_setAssociatedObject(self, &kInteractivePopTransition, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BCMagicTransition *)popTransit
{
    return objc_getAssociatedObject(self, &kPopTransit);
}

- (void)setPopTransit:(BCMagicTransition *)value
{
    
    objc_setAssociatedObject(self, &kPopTransit, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (BCMagicTransition *)pushTransit
{
    return objc_getAssociatedObject(self, &kPushTransit);
}

- (void)setPushTransit:(BCMagicTransition *)value
{
    objc_setAssociatedObject(self, &kPushTransit, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Instance methods

- (void)pushViewController:(UIViewController *)viewController
                  fromView:(UIView *)fromView
                    toView:(UIView *)toView
                  duration:(NSTimeInterval)duration
{
    NSArray *fromViews = [NSArray arrayWithObject:fromView];
    NSArray *toViews = [NSArray arrayWithObject:toView];
    [self pushViewController:viewController fromViews:fromViews toViews:toViews duration:duration];
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
    
    // Add pop gesture and animation to viewcontroller
    UIViewController *transitVC = viewController;
    
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

#pragma mark - <UINavigationControllerDelegate>

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController conformsToProtocol:NSProtocolFromString(@"BCMagicTransitionProtocol")])
    {
        [(UIViewController *)viewController setPushTransit:nil];
    }
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    switch (operation) {
        case UINavigationControllerOperationPush:
        {
            
            if ([fromVC conformsToProtocol:NSProtocolFromString(@"BCMagicTransitionProtocol")] && [fromVC pushTransit])
            {
                return [fromVC pushTransit];
            }
            else
            {
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
            
            if ([fromVC conformsToProtocol:NSProtocolFromString(@"BCMagicTransitionProtocol")] && [fromVC popTransit])
            {
                return [fromVC popTransit];
            }
            else
            {
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
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    
    if ([navigationController.topViewController conformsToProtocol:NSProtocolFromString(@"BCMagicTransitionProtocol")])
    {
        UIViewController *viewController = navigationController.topViewController;
        return viewController.interactivePopTransition;
    }
    
    return nil;
    
}

- (void)handleEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer
{
    
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 0.99);
    progress = MIN(0.99, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        
        [self.interactivePopTransition updateInteractiveTransition:progress];
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        // Finish or cancel the interactive transition
        if (progress > 0.4) {
            [self.interactivePopTransition finishInteractiveTransition];
        } else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        //self.interactivePopTransition = nil;
    }
    
}

@end
