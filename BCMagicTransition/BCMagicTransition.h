//
//  BCMagicTransition.h
//  BCMagicTransition
//
//  Created by Boyce Chang on 10/21/14.
//  Copyright (c) 2014 Boyce Chang. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEFAULT_TRANSITON_DURATION 0.3
#define DEFAULT_TRANSITON_DELAY    0.0
#define DEFAULT_TRANSITON_DAMPING  0.8
#define DEFAULT_TRANSITON_VELOCITY 1.0

@interface BCMagicTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL isMagic;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) CGFloat        damping;
@property (nonatomic, assign) CGFloat        velocity;

@property (nonatomic, strong) NSArray *fromViews;
@property (nonatomic, strong) NSArray *toViews;

@end
