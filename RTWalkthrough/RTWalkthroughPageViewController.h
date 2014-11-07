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


@protocol RTWalkthroughPageViewControllerDelegate;

@interface RTWalkthroughPageViewController : UIViewController

@property (nonatomic) IBInspectable CGPoint speed;
@property (nonatomic) IBInspectable CGPoint speedVariance;
@property (nonatomic) IBInspectable RTWalkthroughAnimationType animationType;
@property (nonatomic) IBInspectable BOOL animateAlpha;

@property (nonatomic, weak) id<RTWalkthroughPageViewControllerDelegate> delegate;

@end


@protocol RTWalkthroughPageViewControllerDelegate <NSObject>

@optional
- (void)walkthroughPageRequestsClosing:(RTWalkthroughPageViewController *)controller;

@end