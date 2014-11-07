RTWalkthrough
=============

An Objective-C clone of [ariok/BWWalkthrough](https://github.com/ariok/BWWalkthrough) (a bit improved in the process)

Please read their explanation, as everything applies here as well. There are few changes though

### animatedSubviews IBOutletCollection

ariok's implementation automatically animates main view's subviews. In the world of `UIVisualEffectsView` this is not always a good approach, as you may have a bunch of controls and views inside such effects view and may want to animate them separatelly. You may also want to leave some subviews static.

`IBOutletCollection` is perfect solution for this. In the storyboard, you simply connect all the subviews, no matter how deep they are.

### AnimationType is an NSInteger-based NS_ENUM

Thus instead of specifying a string for the animation type, you need to remember the proper number to put into IB.
It does make it less readable though, but I'm not aware that ObjC can do non-integer enums, so there you go.

### RTWalkthroughPageViewControllerDelegate

I recommend to make all your pages a subclass of `RTWalkthroughPageViewController` but you are still free to do completely custom page.

If you do as I recommend, you get a nice little delegate call (and can easily extend it as you need) on the page-level, where you can close the walkthrough at any given moment. This is mostly useful for the end page, as it gives you ability to close the walkthrough using jolly big button in the middle of the page.

### Credits

All kudos to Yari D'areglia - BWWalkthrough is the most usable and customizable I have seen, yet so easily approachable component for making introduction tutorials.
