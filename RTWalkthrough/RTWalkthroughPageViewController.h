//
//  RTWalkthroughPageViewController.h
//  Walkthrough
//
//  Created by Aleksandar Vacić on 3.11.14..
//  Copyright (c) 2014. Radiant Tap. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RTWalkthroughAnimationType) {
	RTWalkthroughAnimationTypeLinear,
	RTWalkthroughAnimationTypeCurve,
	RTWalkthroughAnimationTypeZoom,
	RTWalkthroughAnimationTypeInOut
};

@interface RTWalkthroughPageViewController : UIViewController

@property (nonatomic) IBInspectable CGPoint speed;
@property (nonatomic) IBInspectable CGPoint speedVariance;
@property (nonatomic) IBInspectable RTWalkthroughAnimationType animationType;
@property (nonatomic) IBInspectable BOOL animateAlpha;

@end
