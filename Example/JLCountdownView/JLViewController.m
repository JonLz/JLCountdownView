//
//  JLViewController.m
//  JLCountdownView
//
//  Created by Jon on 7/22/14.
//  Copyright (c) 2014 Second Wind, LLC. All rights reserved.
//

#import "JLViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface JLViewController ()
// CountdownView property and delegate method
@property (nonatomic,strong) JLCountdownView *cdv;
- (void)countdownViewDidFinish:(JLCountdownView *)view;

// Ball methods for some fun after the timer counts down
@property (nonatomic,strong) UIView *orangeBall;
@property (nonatomic, strong) UIDynamicAnimator *animator;
-(void)demoGravity;
@end

@implementation JLViewController

# pragma mark View hierarchy methods
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    self.cdv = [JLCountdownView countdownTimerInView:self.view];
    self.cdv.delegate = self;
    
    int width = 50;
    int screenHeight = self.view.bounds.size.height;
    UIButton *start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    start.frame = CGRectMake(320/2-width/2, screenHeight/2+50, width, width);
    [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [start setTitle:@"Start" forState:UIControlStateNormal];
    [self.view addSubview:start];
    
    start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    start.frame = CGRectMake(320/2-width/2, screenHeight/2+50 + width, width, width);
    [start addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [start setTitle:@"Pause" forState:UIControlStateNormal];
    [self.view addSubview:start];
    
    start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    start.frame = CGRectMake(320/2-width/2, screenHeight/2+50 + width*2, width, width);
    [start addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
    [start setTitle:@"Restart" forState:UIControlStateNormal];
    [self.view addSubview:start];

}

#pragma mark
#pragma mark UI Controls
- (void)start
{
    [self.cdv start];
}

- (void)pause
{
    [self.cdv pause];
}

- (void)restart
{
    [self.orangeBall removeFromSuperview];
    [self.view addSubview:self.cdv];
    [self.cdv restart];
}

# pragma mark
# pragma mark Delegate methods
- (void)countdownViewDidFinish:(JLCountdownView *)view
{
    // Setup the ball view.
    self.orangeBall = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-25, self.view.center.y-25, 50.0, 50.0)];
    self.orangeBall.backgroundColor = [UIColor orangeColor];
    self.orangeBall.layer.cornerRadius = 25.0;
    self.orangeBall.layer.borderColor = [UIColor blackColor].CGColor;
    self.orangeBall.layer.borderWidth = 0.0;
    [self.view addSubview:self.orangeBall];
    
    // Initialize the animator.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    // Get rid of the countdown and start the ball animation
    [self.cdv removeFromSuperview];
    [self demoGravity];
}

#pragma mark
#pragma mark Ball methods
- (void)demoGravity
{
    // Ball should have gravity
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.orangeBall]];
    [self.animator addBehavior:gravityBehavior];
    
    // Ball should collide with the bottom of the screen
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.orangeBall]];
    [collisionBehavior addBoundaryWithIdentifier:@"tabbar"
                                       fromPoint:CGPointMake(0, self.view.bounds.size.height)
                                         toPoint:CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.animator addBehavior:collisionBehavior];
    
    // Ball should exhibit some elasticity
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.orangeBall]];
    ballBehavior.elasticity = 0.75;
    [self.animator addBehavior:ballBehavior];
}

# pragma mark
# pragma mark Apple methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
