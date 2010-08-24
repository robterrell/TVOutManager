//
//  TVOutOS4TestAppDelegate.h
//  TVOutOS4Test
//
//  Created by Rob Terrell (rob@touchcentric.com) on 7/6/10.
//  Copyright TouchCentric LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface TVOutOS4TestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end

