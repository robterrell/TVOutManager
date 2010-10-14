//
//  MainViewController.m
//  TVOutOS4Test
//
//  Created by Rob Terrell (rob@touchcentric.com) on 7/6/10.
//  Copyright TouchCentric LLC 2010. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

- (id)init
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[super initWithNibName:@"MainView~ipad" bundle:nil];
	} else {
		[super initWithNibName:@"MainView" bundle:nil];
	}

	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(screenDidConnectNotification:) name: UIScreenDidConnectNotification object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(screenDidDisconnectNotification:) name: UIScreenDidDisconnectNotification object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(screenModeDidChangeNotification:) name: UIScreenModeDidChangeNotification object: nil];
	
    return self;
}

- (id)initWithNibName:(NSString *)n bundle:(NSBundle *)b
{
    return [self init];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self runTimer];
	[super viewDidLoad];
}


- (void)runTimer {
	// This starts the timer which fires the showActivity
	// method every 0.5 seconds
	myTicker = [NSTimer scheduledTimerWithTimeInterval: 0.5
												target: self
											  selector: @selector(showActivity)
											  userInfo: nil
											   repeats: YES];
	
}

// This method is run every 0.5 seconds by the timer created
// in the function runTimer
- (void)showActivity {
	
	NSDateFormatter *formatter =
	[[[NSDateFormatter alloc] init] autorelease];
    NSDate *date = [NSDate date];
	
    // This will produce a time that looks like "12:15:00 PM".
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
	
	// This sets the label with the updated time.
	[clockLabel setText:[formatter stringFromDate:date]];
	
}

-(void) toggleSafeMode: (id) sender
{
	[TVOutManager sharedInstance].tvSafeMode = tvSwitch.on;
}

-(void) toggleVideoOutput: (id) sender
{
	if (videoSwitch.on) [[TVOutManager sharedInstance] startTVOut];
	else [[TVOutManager sharedInstance] stopTVOut];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) implementationChanged: (id) sender
{
	UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
	
	if(videoSwitch.on)
	{
		[[TVOutManager sharedInstance] stopTVOut];
	}
	
	if(segmentedControl.selectedSegmentIndex == 0)
	{
		[[TVOutManager sharedInstance] setImplementation:kTVOutImplementationMainThread];
	}
	else if(segmentedControl.selectedSegmentIndex == 1)
	{
		[[TVOutManager sharedInstance] setImplementation:kTVOutImplementationBackgroundThread];
	}
	else if(segmentedControl.selectedSegmentIndex == 2)
	{
		[[TVOutManager sharedInstance] setImplementation:kTVOutImplementationCADisplayLink];
	}
	
	if(videoSwitch.on)
	{
		[[TVOutManager sharedInstance] startTVOut];
	}
}

- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}



- (void)dealloc {
    [super dealloc];
}

#pragma mark Notifications

-(void) screenDidConnectNotification: (NSNotification*) notification
{
	infoLabel.text = [NSString stringWithFormat: @"Screen connected: %@", [[notification object] description]];
}

-(void) screenDidDisconnectNotification: (NSNotification*) notification
{
	infoLabel.text = [NSString stringWithFormat: @"Screen disconnected: %@", [[notification object] description]];
}

-(void) screenModeDidChangeNotification: (NSNotification*) notification
{
	infoLabel.text = [NSString stringWithFormat: @"Screen mode changed: %@", [[notification object] description]];
}



@end
