//
//  SecondViewController.m
//  MagicTransition
//
//  Created by Boyce on 10/31/14.
//  Copyright (c) 2014 Boyce. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)push:(id)sender {
    ThirdViewController *thirdVC = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];
    
    // preload views to the memory
    [thirdVC loadView];
  
    
    // setup fromviews array and toviews array
    NSArray *fromViews = [NSArray arrayWithObjects:self.imageView1, self.imageView2, self.label1, nil];
    NSArray *toViews = [NSArray arrayWithObjects:thirdVC.imageView1, thirdVC.imageView2, thirdVC.label1, nil];
    
    [self pushViewController:thirdVC fromViews:fromViews toViews:toViews duration:0.7];
}

@end
