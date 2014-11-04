//
//  RTWalkthroughViewController.h
//  Walkthrough
//
//  Created by Aleksandar Vacić on 3.11.14..
//  Copyright (c) 2014. Radiant Tap. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTWalkthroughViewControllerDelegate;

@interface RTWalkthroughViewController : UIViewController

@property (nonatomic, weak) id<RTWalkthroughViewControllerDelegate> delegate;
@property (nonatomic, readonly) NSInteger currentPage;
- (void)addViewController:(UIViewController *)vc;

@end


@protocol RTWalkthroughViewControllerDelegate <NSObject>

@optional
- (void)walkthroughControllerDidClose:(RTWalkthroughViewController *)controller;
- (void)walkthroughControllerWentNext:(RTWalkthroughViewController *)controller;
- (void)walkthroughControllerWentPrev:(RTWalkthroughViewController *)controller;
- (void)walkthroughController:(RTWalkthroughViewController *)controller didChangeToPage:(NSInteger)page;

@end


@protocol RTWalkthroughPage <NSObject>

- (void)walkthroughDidScrollToPosition:(CGFloat)position offset:(CGFloat)offset;

@end