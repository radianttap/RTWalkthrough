//
//  RTWalkthroughPageViewController.m
//  Walkthrough
//
//  Created by Aleksandar Vacić on 3.11.14..
//  Copyright (c) 2014. Radiant Tap. All rights reserved.
//

#import "RTWalkthroughPageViewController.h"
#import "RTWalkthroughViewController.h"
@import QuartzCore;

@interface RTWalkthroughPageViewController () < RTWalkthroughPage >

@property (nonatomic, strong) NSMutableArray *subsWeights;

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *animatedSubviews;

@end

@implementation RTWalkthroughPageViewController

- (BOOL)shouldAutorotate {
	
	return NO;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder:aDecoder];
	if (!self) return nil;
	
	_speed = CGPointZero;
	_speedVariance = CGPointZero;
	_animationType = RTWalkthroughAnimationTypeLinear;
	_animateAlpha = NO;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.layer.masksToBounds = YES;
	self.subsWeights = [NSMutableArray array];
	
	for (UIView *v in self.animatedSubviews) {
		CGPoint speed = self.speed;
		speed.x += self.speedVariance.x;
		speed.y += self.speedVariance.y;
		[self.subsWeights addObject:[NSValue valueWithCGPoint:speed]];
		self.speed = speed;
	}
}

- (void)walkthroughDidScrollToPosition:(CGFloat)position offset:(CGFloat)offset {
	
	for (NSInteger i = 0; i < self.subsWeights.count;i++) {
		
		// Perform Transition/Scale/Rotate animations
		switch (self.animationType) {
			case RTWalkthroughAnimationTypeLinear:
				[self animationLinear:i offset:offset];
				break;
			case RTWalkthroughAnimationTypeCurve:
				[self animationCurve:i offset:offset];
				break;
			case RTWalkthroughAnimationTypeZoom:
				[self animationZoom:i offset:offset];
				break;
			case RTWalkthroughAnimationTypeInOut:
				[self animationInOut:i offset:offset];
				break;
		}
		
		// Animate alpha
		if (self.animateAlpha){
			[self animationAlpha:i offset:offset];
		}
	}
}

// MARK: Animations (WIP)

- (void)animationAlpha:(NSInteger)index offset:(CGFloat)offset {
	UIView *cView = self.animatedSubviews[index];
	
	if (offset > 1.0){
		offset = 1.0 + (1.0 - offset);
	}
	cView.alpha = offset;
}

- (void)animationCurve:(NSInteger)index offset:(CGFloat)offset {
	CATransform3D transform = CATransform3DIdentity;
	CGFloat x = (1.0 - offset) * 10;
	CGPoint p = [self.subsWeights[index] CGPointValue];
	transform = CATransform3DTranslate(transform, (pow(x,3) - (x * 25)) * p.x, (pow(x,3) - (x * 20)) * p.y, 0 );
	((UIView *)self.animatedSubviews[index]).layer.transform = transform;
}

- (void)animationZoom:(NSInteger)index offset:(CGFloat)offset {
	CATransform3D transform = CATransform3DIdentity;
	
	CGFloat tmpOffset = offset;
	if (tmpOffset > 1.0){
		tmpOffset = 1.0 + (1.0 - tmpOffset);
	}
	CGFloat scale = (1.0 - tmpOffset);
	transform = CATransform3DScale(transform, 1 - scale , 1 - scale, 1.0);
	((UIView *)self.animatedSubviews[index]).layer.transform = transform;
}

- (void)animationLinear:(NSInteger)index offset:(CGFloat)offset {
	CATransform3D transform = CATransform3DIdentity;
	CGFloat mx = (1.0 - offset) * 100;
	CGPoint p = [self.subsWeights[index] CGPointValue];
	transform = CATransform3DTranslate(transform, mx * p.x, mx * p.y, 0 );
	((UIView *)self.animatedSubviews[index]).layer.transform = transform;
}

- (void)animationInOut:(NSInteger)index offset:(CGFloat)offset {
	CATransform3D transform = CATransform3DIdentity;
//	CGFloat x = (1.0 - offset) * 20;
	
	CGFloat tmpOffset = offset;
	if (tmpOffset > 1.0){
		tmpOffset = 1.0 + (1.0 - tmpOffset);
	}
	CGPoint p = [self.subsWeights[index] CGPointValue];
	transform = CATransform3DTranslate(transform, (1.0 - tmpOffset) * p.x * 100, (1.0 - tmpOffset) * p.y * 100, 0);
	((UIView *)self.animatedSubviews[index]).layer.transform = transform;
}

@end
