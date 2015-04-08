//
//  BCMagicTransition.h
//  BCMagicTransition
//
//  Created by Xaiobo Zhang on 10/21/14.
//  Copyright (c) 2014 Xaiobo Zhang. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BCMagicTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL isMagic;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) NSArray *fromViews;
@property (nonatomic, strong) NSArray *toViews;

@end
