//
//  MainViewController.h
//  TVOutOS4Test
//
//  Created by Rob Terrell (rob@touchcentric.com) on 7/6/10.
//  Copyright TouchCentric LLC 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "TVOutManager.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	IBOutlet UILabel* clockLabel;
	NSTimer *myTicker;
	IBOutlet UITextView* infoLabel;
	IBOutlet UISwitch* tvSwitch;
	IBOutlet UISwitch* videoSwitch;
}

- (IBAction)showInfo:(id)sender;
- (void)runTimer;
- (IBAction) toggleSafeMode: (id) sender;
- (IBAction) toggleVideoOutput: (id) sender;

@end
