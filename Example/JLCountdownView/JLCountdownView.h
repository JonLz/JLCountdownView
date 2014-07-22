//
//  JLCountdownView.h
//  JLCountdownView
//
//  Created by Jon on 7/22/14.
//  Copyright (c) 2014 Second Wind, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLCountdownView;
@protocol JLCountdownViewDelegate <NSObject>
@optional
- (void)countdownViewDidFinish:(JLCountdownView *)view;
@end

@interface JLCountdownView : UIView

@property (nonatomic,weak) id <JLCountdownViewDelegate> delegate;

@property (nonatomic,strong) UIColor *circleColor;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,assign) CGPoint point;
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,assign) NSInteger timeInterval;

// Timer methods
- (void)start;
- (void)pause;
- (void)restart;

// Constructor for a centered in-place timer counting down from 3 with an orange circle and white text
+ (instancetype)countdownTimerInView:(UIView *)view;

// Custom constructor to set the point and size of the circle (and time (optional))
+ (instancetype)countdownTimerAtPoint:(CGPoint)point radius:(CGFloat)radius;
+ (instancetype)countdownTimerAtPoint:(CGPoint)point radius:(CGFloat)radius time:(NSInteger)time;

// Custom setter to set time and reset remaining time
- (void)setTime:(NSInteger)time;

// Custom setters to set radius and point and recalculate the frames
- (void)setRadius:(CGFloat)radius;
- (void)setPoint:(CGPoint)point;

@end
