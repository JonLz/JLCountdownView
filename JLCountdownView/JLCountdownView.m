//
//  JLCountdownView.m
//  JLCountdownView
//
//  Created by Jon on 7/22/14.
//  Copyright (c) 2014 Second Wind, LLC. All rights reserved.
//

#import "JLCountdownView.h"


@interface JLCountdownView () {
    NSInteger timeLeft;
    BOOL running;
}
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIView *circleView;
@property (nonatomic,strong) NSTimer *timer;
@property (assign) CGRect viewFrame;
@end

@implementation JLCountdownView

static const CGFloat defaultTime = 3;
static const CGFloat defaultTimeInterval = 1;
static const CGFloat defaultRadius = 25;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

// Easy constructor for a default countdown view in a parent view
+(instancetype)countdownTimerInView:(UIView *)view
{
    JLCountdownView *cdv = [JLCountdownView countdownTimerAtPoint:CGPointMake(view.center.x,view.center.y) radius:defaultRadius];
    [view addSubview:cdv];
    return cdv;
}


+(instancetype)countdownTimerAtPoint:(CGPoint)point radius:(CGFloat)radius
{
	JLCountdownView *cdv = [[JLCountdownView alloc] init];
    cdv.radius = radius;
    cdv.point = point;
    cdv.time = defaultTime;
	cdv.timeInterval = defaultTimeInterval;
    
	// Default setup, white text on orange background
    cdv.backgroundColor = [UIColor clearColor];
    
    // Orange - Carrot color from Flat UI colors
	cdv.circleColor = [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1];
    
    // White - Clouds color from Flat UI colors
	cdv.textColor = [UIColor colorWithRed:236/255.0 green:240/255.0 blue:240/255.0 alpha:1];
	cdv.textFont = [UIFont systemFontOfSize:30];
	
	return cdv;
}

+(instancetype)countdownTimerAtPoint:(CGPoint)point radius:(CGFloat)radius time:(NSInteger)time
{
    JLCountdownView *cdv = [JLCountdownView countdownTimerAtPoint:point radius:radius];
    cdv.time = time;
    return cdv;
}

- (void)start
{
    running = YES;
    if (!timeLeft <= 0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    }
}

- (void)pause
{
    [self.timer invalidate];
}

- (void)restart
{
    [self.timer invalidate];
    [self setTime:self.time];
    [self setNeedsDisplay];
    [self start];
}

- (void)didFinishCountdown
{
    if ([self.delegate respondsToSelector:@selector(countdownViewDidFinish:)]) {
        [self.delegate countdownViewDidFinish:self];
    }
}

- (void)drawRect:(CGRect)rect
{
	// Draw the circle
	if (!self.circleView) {
		self.circleView = [[UIView alloc] initWithFrame:self.viewFrame];
		self.circleView.layer.cornerRadius = self.circleView.frame.size.height/2;
		self.circleView.alpha = 1;
		self.circleView.backgroundColor = self.circleColor;
		[self addSubview:self.circleView];
	}
	
	// Draw the number
	if (!self.textLabel) {
		self.textLabel = [[UILabel alloc] initWithFrame:self.viewFrame];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
		self.textLabel.textColor = self.textColor;
		self.textLabel.font = self.textFont;
		[self addSubview:self.textLabel];
	}
	self.textLabel.text = [NSString stringWithFormat:@"%d",timeLeft];
    
	// Run the circle animation
    // Small -> Large -> Normal
    if (running) {
        [UIView animateWithDuration:self.timeInterval * 0.33
            animations:^{
                self.circleView.transform = CGAffineTransformMakeScale(0.6,0.6); }
            completion:^(BOOL finished) {
            
                [UIView animateWithDuration:self.timeInterval * 0.33
                    animations: ^ {
                        self.circleView.transform = CGAffineTransformMakeScale(1.15,1.15);}
                    completion:^ (BOOL finished) {
                
                        [UIView animateWithDuration:self.timeInterval * 0.34
                            animations:^{
                                self.circleView.transform = CGAffineTransformMakeScale(1, 1);}
                            completion:nil];
                }];
        }];
    }
    // Decrement the timer - placed here to ensure timing and drawing are on the same thread
    if (timeLeft == 0) {
        [self.timer invalidate];
        [self didFinishCountdown];
        running = NO;
    }
    timeLeft -= self.timeInterval;
}

- (void)setTime:(NSInteger)time
{
    _time = time;
    timeLeft = time;
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    self.viewFrame = CGRectMake(0, 0, _radius*2, _radius*2);
}

- (void)setPoint:(CGPoint)point
{
    _point = point;
    self.frame = CGRectMake(point.x-_radius, point.y-_radius, _radius*2, _radius*2);
}

@end
