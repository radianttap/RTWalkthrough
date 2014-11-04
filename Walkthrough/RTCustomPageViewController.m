//
//  RTCustomPageViewController.m
//  Walkthrough
//
//  Created by Aleksandar Vacić on 4.11.14..
//  Copyright (c) 2014. Radiant Tap. All rights reserved.
//

#import "RTCustomPageViewController.h"
#import "RTWalkthroughViewController.h"

@interface RTCustomPageViewController () < RTWalkthroughPage >

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;

@end

@implementation RTCustomPageViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)walkthroughDidScrollToPosition:(CGFloat)position offset:(CGFloat)offset {

	CATransform3D tr = CATransform3DIdentity;
	tr.m34 = -1/500.0;
	
	self.titleLabel.layer.transform = CATransform3DRotate(tr, (CGFloat)M_PI * (1.0 - offset), 1, 1, 1);
	self.textLabel.layer.transform = CATransform3DRotate(tr, (CGFloat)M_PI * (1.0 - offset), 1, 1, 1);

	CGFloat tmpOffset = offset;
	if (tmpOffset > 1.0){
		tmpOffset = 1.0 + (1.0 - tmpOffset);
	}
	self.imageView.layer.transform = CATransform3DTranslate(tr, 0 , (1.0 - tmpOffset) * 200, 0);
}

@end
