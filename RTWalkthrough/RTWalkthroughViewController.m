//
//  RTWalkthroughViewController.m
//  Walkthrough
//
//  Created by Aleksandar Vacić on 3.11.14..
//  Copyright (c) 2014. Radiant Tap. All rights reserved.
//

#import "RTWalkthroughViewController.h"

@interface RTWalkthroughViewController () < UIScrollViewDelegate >

@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) IBOutlet UIButton *prevButton;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;

// MARK: - Private properties -
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) NSArray *lastViewConstraint;

@end

@implementation RTWalkthroughViewController


- (NSInteger)currentPage {
	
	NSInteger page = lrint((self.scrollview.contentOffset.x / self.view.bounds.size.width));
	return page;
}

- (instancetype)init {
	
	self = [super init];
	if (!self) return nil;

	self.scrollview = [[UIScrollView alloc] init];
	self.controllers = [NSMutableArray array];
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder:aDecoder];
	if (!self) return nil;
	
	self.scrollview = [[UIScrollView alloc] init];
	self.scrollview.showsHorizontalScrollIndicator = NO;
	self.scrollview.showsVerticalScrollIndicator = NO;
	self.scrollview.pagingEnabled = YES;

	self.controllers = [NSMutableArray array];
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.scrollview.delegate = self;
	self.scrollview.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view insertSubview:self.scrollview atIndex:0];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollview]|" options:0 metrics:nil views:@{@"scrollview":self.scrollview}]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollview]|" options:0 metrics:nil views:@{@"scrollview":self.scrollview}]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.pageControl.numberOfPages = [self.controllers count];
	self.pageControl.currentPage = 0;
}

- (IBAction)nextPage:(id)sender {
	
	if ((self.currentPage + 1) < self.controllers.count) {
		
		if ([self.delegate respondsToSelector:@selector(walkthroughControllerWentNext:)])
			[self.delegate walkthroughControllerWentNext:self];
		
		CGRect frame = self.scrollview.frame;
		frame.origin.x = (CGFloat)(self.currentPage + 1) * frame.size.width;
//		[self.scrollview scrollRectToVisible:frame animated:YES];
		[self.scrollview setContentOffset:frame.origin animated:YES];
	}
}

- (IBAction)prevPage:(id)sender {
	
	if (self.currentPage > 0) {
		
		if ([self.delegate respondsToSelector:@selector(walkthroughControllerWentPrev:)])
			[self.delegate walkthroughControllerWentPrev:self];
		
		CGRect frame = self.scrollview.frame;
		frame.origin.x = (CGFloat)(self.currentPage - 1) * frame.size.width;
		[self.scrollview scrollRectToVisible:frame animated:YES];
		[self.scrollview setContentOffset:frame.origin animated:YES];
	}
}

- (IBAction)close:(id)sender {
	
	if ([self.delegate respondsToSelector:@selector(walkthroughControllerDidClose:)])
		[self.delegate walkthroughControllerDidClose:self];
}

- (void)addViewController:(UIViewController *)vc {
	
	[self.controllers addObject:vc];
	
	// Setup the viewController view
	
	vc.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.scrollview addSubview:vc.view];
	
	// Constraints
	
	NSDictionary *metrics = @{@"w":@(vc.view.bounds.size.width),@"h":@(vc.view.bounds.size.height)};
	
	// - Generic cnst
	
	[vc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[view(w)]" options:0 metrics:metrics views:@{@"view":vc.view}]];
	[vc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(h)]" options:0 metrics:metrics views:@{@"view":vc.view}]];
	[self.scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]" options:0 metrics:nil views:@{@"view":vc.view}]];

	// cnst for position: 1st element
	
	if (self.controllers.count == 1) {
		[self.scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[view]" options:0 metrics:nil views:@{@"view":vc.view}]];
		
		// cnst for position: other elements
		
	} else{
		
		UIViewController *previousVC = self.controllers[self.controllers.count-2];
		UIView *previousView = previousVC.view;
		
		[self.scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[previousView]-0-[view]" options:0 metrics:nil views:@{@"previousView":previousView, @"view":vc.view}]];
		
		if (self.lastViewConstraint) {
			[self.scrollview removeConstraints:self.lastViewConstraint];
		}
		
		self.lastViewConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-|" options:0 metrics:nil views:@{@"view":vc.view}];
		[self.scrollview addConstraints:self.lastViewConstraint];
	}
}

#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	for (NSInteger i=0; i < self.controllers.count; i++) {
		
		UIViewController<RTWalkthroughPage> *vc = self.controllers[i];
		if ([vc respondsToSelector:@selector(walkthroughDidScrollToPosition:offset:)]) {
			
			CGFloat mx = ((self.scrollview.contentOffset.x + self.view.bounds.size.width) - (self.view.bounds.size.width * (CGFloat)i)) / self.view.bounds.size.width;
			
			// While sliding to the "next" slide (from right to left), the "current" slide changes its offset from 1.0 to 2.0 while the "next" slide changes it from 0.0 to 1.0
			// While sliding to the "previous" slide (left to right), the current slide changes its offset from 1.0 to 0.0 while the "previous" slide changes it from 2.0 to 1.0
			// The other pages update their offsets whith values like 2.0, 3.0, -2.0... depending on their positions and on the status of the walkthrough
			// This value can be used on the previous, current and next page to perform custom animations on page's subviews.
			
			// print the mx value to get more info.
			// println("\(i):\(mx)")
			
			// We animate only the previous, current and next page
			if (mx < 2 && mx > -2.0){
				[vc walkthroughDidScrollToPosition:self.scrollview.contentOffset.x offset:mx];
			}
		}
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self updateUI];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	[self updateUI];
}

- (void)updateUI {
	
	// Get the current page
	self.pageControl.currentPage = self.currentPage;

	// Notify delegate about the new page
	
	if ([self.delegate respondsToSelector:@selector(walkthroughController:didChangeToPage:)]) {
		[self.delegate walkthroughController:self didChangeToPage:self.currentPage];
	}
	
	// Hide/Show navigation buttons
	
	self.nextButton.hidden = (self.currentPage == self.controllers.count - 1);
	self.prevButton.hidden = (self.currentPage == 0);
}

@end
