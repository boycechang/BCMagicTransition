//
//  BCInteractiveTransition.h
//  Demo
//
//  Created by Boyce Chang on 7/6/15.
//  Copyright (c) 2015 Boyce Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, BCInteractiveTransitionType) {
    BCInteractiveTransitionTypeEdgePan = 0,
    BCInteractiveTransitionTypeSwipeDown,
};



@interface BCInteractiveTransition : UIPercentDrivenInteractiveTransition

+ (BCInteractiveTransition *)transitionWithType:(BCInteractiveTransitionType)type;

@property (nonatomic, assign) BOOL interacting;

- (void)attachToViewController:(UIViewController*)viewController;

@end
