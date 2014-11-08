//
//  BCMagicTransitViewController.m
//  BCMagicTransit
//
//  Created by Xaiobo Zhang on 10/22/14.
//  Copyright (c) 2014 Xaiobo Zhang. All rights reserved.
//

#import "BCMagicTransitViewController.h"

#define DEFAULT_TRANSITON_DURATION 0.3

@interface BCMagicTransitViewController ()

@end

@implementation BCMagicTransitViewController

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

- (void)pushViewController:(BCMagicTransitViewController *)viewController fromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration{
    NSArray *fromViews = [NSArray arrayWithObject:fromView];
    NSArray *toViews = [NSArray arrayWithObject:toView];
    [self pushViewController:(BCMagicTransitViewController *)viewController fromViews:fromViews toViews:toViews duration:duration];
}

- (void)pushViewController:(BCMagicTransitViewController *)viewController fromViews:(NSArray *)fromViews toViews:(NSArray *)toViews duration:(NSTimeInterval)duration
{
    // 生成此次Push的Transition，因为一个controller可能多次push，每次使用完需要在回调中清除
    BCMagicTransit *magicPush = [BCMagicTransit new];
    magicPush.isMagic = YES;
    magicPush.isPush = YES;
    magicPush.duration = duration;
    magicPush.fromViews = fromViews;
    magicPush.toViews = toViews;
    self.pushTransit = magicPush;
    self.navigationController.delegate = self;
    
    // 为下一层添加返回手势和动画
    BCMagicTransitViewController *transitVC = (BCMagicTransitViewController *)viewController;
    
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanGestureRecognizer:)];
    popRecognizer.edges = UIRectEdgeLeft;
    [transitVC.view addGestureRecognizer:popRecognizer];
    
    BCMagicTransit *magicPop = [BCMagicTransit new];
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
    if ([viewController isKindOfClass:[BCMagicTransitViewController class]])
        [(BCMagicTransitViewController *)viewController setPushTransit:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    switch (operation) {
        case UINavigationControllerOperationPush:
        {
            if ([fromVC isKindOfClass:[BCMagicTransitViewController class]] && [(BCMagicTransitViewController *)fromVC pushTransit]) {
                return [(BCMagicTransitViewController *)fromVC pushTransit];
            } else {
                BCMagicTransit *normalPush = [BCMagicTransit new];
                normalPush.isMagic = NO;
                normalPush.isPush = YES;
                normalPush.duration = DEFAULT_TRANSITON_DURATION;
                return normalPush;
            }
        }
            break;
        case UINavigationControllerOperationPop:
        {
            if ([fromVC isKindOfClass:[BCMagicTransitViewController class]] && [(BCMagicTransitViewController *)fromVC popTransit]) {
                return [(BCMagicTransitViewController *)fromVC popTransit];
            } else {
                BCMagicTransit *normalPop = [BCMagicTransit new];
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
    if ([navigationController.topViewController isKindOfClass:[BCMagicTransitViewController class]]) {
        BCMagicTransitViewController *viewController = (BCMagicTransitViewController *)navigationController.topViewController;
        return viewController.interactivePopTransition;
    } else {
        return nil;
    }
}


- (void)handleEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        [self.interactivePopTransition updateInteractiveTransition:progress];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        } else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}

@end
