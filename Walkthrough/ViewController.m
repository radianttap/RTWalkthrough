//
//  ViewController.m
//  Walkthrough
//
//  Created by Aleksandar Vacić on 3.11.14..
//  Copyright (c) 2014. Radiant Tap. All rights reserved.
//

#import "ViewController.h"
#import "RTWalkthroughPageViewController.h"
#import "RTWalkthroughViewController.h"

@interface ViewController () < RTWalkthroughViewControllerDelegate >

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL presented = [defaults boolForKey:@"walkthroughPresented"];
	
	if (!presented) {
		[self showWalkthrough:nil];
		
		[defaults setBool:YES forKey:@"walkthroughPresented"];
		[defaults synchronize];
	}
}

- (IBAction)showWalkthrough:(id)sender {
	
	UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Walkthrough" bundle:nil];
	RTWalkthroughViewController *walkthrough = [stb instantiateViewControllerWithIdentifier:@"walk"];

	RTWalkthroughPageViewController *pageZero = [stb instantiateViewControllerWithIdentifier:@"walk0"];
	RTWalkthroughPageViewController *pageOne = [stb instantiateViewControllerWithIdentifier:@"walk1"];
	RTWalkthroughPageViewController *pageTwo = [stb instantiateViewControllerWithIdentifier:@"walk2"];
	RTWalkthroughPageViewController *pageThree = [stb instantiateViewControllerWithIdentifier:@"walk3"];
	
	walkthrough.delegate = self;
	[walkthrough addViewController:pageOne];
	[walkthrough addViewController:pageTwo];
	[walkthrough addViewController:pageThree];
	[walkthrough addViewController:pageZero];
	
	[self presentViewController:walkthrough animated:YES completion:nil];
}

- (void)walkthroughControllerDidClose:(RTWalkthroughViewController *)controller {
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
