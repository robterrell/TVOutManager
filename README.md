iPhone App Video Mirroring for iOS 4
====================================

(For the most current documentation, see http://www.touchcentric.com/blog/archives/123)

Be Like Steve! 
--------------

Project the video of your iPhone app to thousands of adoring fans! This is an iOS 4.0 rewrite of the TVOut code presented here: http://www.touchcentric.com/blog/archives/3 

I wrote the original code so our local iPhone Developer's Meetup could show off our apps to each other. Since then it's been used by hundreds of developers. It's invaluable for group demos, trade shows, client meetings, investor pitches, and so on. Sadly, iOS 4.0 completely broke the old code, so a rewrite was necessary. Happily iOS 4 makes previously difficult things fairly easy. 

Bonus: this code is now entirely safe for the App Store. Zero private APIs are used. (You do have the option to use one, as you'll see below, but it's turned off by default.)


What's New
----------

Like before, this is a fire-and-forget solution to mirroring the display of your iOS device (iPhone, iPod Touch, iPad) on an external display. The new version uses public APIs, so it can be used in apps published on the App Store. It supports detecting cabling (plugging and unplugging the display), orientation changes, and even offers a "tv safe mode" for displaying your app on an older analog video device. (You probably don't even know what that is, because you're a young whippersnapper who grew up with LCD flatscreen TVs, whereas I am testing this code on my old beloved Apple ][+ color display, and thus find the TV safe mode handy.)

Under the hood, new in this release is the TVOutManager singleton class. In the previous release, I'd made the TVOut manager code as a category on UIApplication, thinking that would make it easier to use and simpler to understand. Based on the emails I got, I think it was definitely simple to use, although not really simpler to understand. 

So now TVOutManager is its own class. It's a singleton, so you simply invoke commands on the shared instance. For example, here's how you start showing video:

	[[TVOutManager sharedInstance] startTVOut];

Stopping is just as easy:

    [[TVOutManager sharedInstance] stopTVOut];

While the cable is connected, changes to the device orientation are tracked and the mirrored output is rotated (with a little animation effect).


Compatibility Note
------------------

This class relies on certain APIs (i.e. [UIScreen screens]) that only exist in iOS SDK 3.2 and above. If you need to support older devices, you'll have to use the older version (http://www.touchcentric.com/blog/archives/3).


Connections and re-connections
------------------------------

While the TV output is running, if the video output cable is disconnected, the class will catch a notification, and stop sending video to the external window. Likewise, if a video output cable is connected, the class will catch that notification, and automatically start showing the video. 

Note that you can use either the VGA output cable, composite video out cable, or the component video output cable. I have tested all three cables on both iPads and an iPhone 4 and found that all cables work on all devices. I'm not sure about iPhone 3GS and older devices, though -- those devices may not support the VGA cable, although they certainly do support the composite and component cables.


App-Store Safe!
---------------

Unlike the previous version, this class uses app-store safe methods. You can ship apps that use this code. We are using an Apple-approvied safe-and-friendly method of collecting bitmaps of all visible windows, and then drawing that bitmap on the external screen, which is also displayed using Apple-approved non-private APIs. 

The previous version used the MPTVOutWindow class, which seems have to disappeared from iOS 4.0, and UIGetScreenImage() to copy the image of the screen. MPTVOutWindow has always been forbidden, but for a brief time, Apple allowed apps using UIGetScreenImage() onto the store (from December of 2009 until July 2010). However, with the release of iOS 4.0, Apple stuck the "private" designation on it again, and apps are once again being rejected for it. (Apple's terrible communciation with developers generally means that developers learn this by submitting an app and getting rejected.)

So, here I've made use of UIGetScreenImage() an option. Why would you ever use it? For one thing, in my testing it's quicker than the non-private methods. It also captures the entire screen display, including the status bar, which is handy for our particular use. UIGetScreenImage() also captures the output of EAGLViews, which the Apple-approved method does not (although Apple does have yet another method for getting that).


OpenGL Support
--------------

There was widespread belief that the pervious version wouldn't work with OpenGL. That mistaken belief came from me -- I didn't realize that UIGetScreenImage() would capture the contents of an OpenGL view. In fact, it does, and it works great. 

I dropped this new TVOutManager version into a simple test project made with the Unity 3 beta (http://unity3d.com), added one line to the AppController.mm file to call -startTVOut, and changed the USE_UIGETSCREENIMAGE constant to YES. The Unity game played on the TV screen. The framerate dropped from 30 fps to about 26 fps. Definitely watchable and playable. (I've gotten into a bad habit of playtesting Unity games on a big screen TV.)

Using UIGetScreenImage means you can't ship this code; it's just for demos. If you need to ship TV out code, you'll have to change the class to follow Apple's example of converting an EAGLView to a UIImage at http://developer.apple.com/iphone/library/qa/qa2010/qa1704.html. If there's demand, I can add this to the TVOutManager in a future release.


Debugging with the Video Out Cable Attached
-------------------------------------------

Obviously you can't debug an app in XCode without having the device connected via USB. Likewise, you can't view the video output without having the VGA cable attached. So debugging was basically impossible.

Thankfully the latest Simulator includes an option to show an external display, but the simulator can't start and stop this external display while the app is running, so it can't be used to debug notifications like UIScreenDidConnectNotification.

To work around the problem, I figured I'd have to buy or make a Y-adapter cable: strip down the VGA cable to see what pins it used, and either wire in a USB connector, or make a full Y adapter that merged the pins required for both cable. Intensive Googling led to parts I could buy from Sparkfun (http://www.sparkfun.com/commerce/product_info.php?products_id=8035). Reality set in (these days I don't have much free time for tinkering and soldering) and I started to look for something a bit more prefab.

<image src="http://images.acco.com/KENSINGTON/K33368/K33368-15105.jpg">

Reading some ancient forum posts about iPod dock issues, I found a reference to the Kensington K33368 "4-in-1 Car Charger," which is a USB cable that includes a full pass-through dock connector, intended for an FM tuner. I guessed that they'd have wired all of the pins, and it would allow me to plug a second dock cable into the first. These are no longer manufactured, but a few online stores still had stock. I ended up buying one from a seller on eBay. It turned out to work perfectly. I plugged the Kensington cable into my Mac, and the RCA video out or VGA cable into the Kensington cable, and was able to debug away. I highly recommend this setup if you need to debug while watching the display on the big screen.



Improvements Needed
-------------------

Currently, device rotation is correctly tracked for the Portrait and Landscape Left initial starting positions. You can turn the device 90 degrees to the left or right and the view on the external monitor will rotate to match. (There's even a nice animated rotation of the screen contents on the external video window.) However, portraitUpsideDown is not handled. And it's possible to confuse it.

This would be easily fixable if we knew what the previous orientation was, but since the UIDeviceOrientationDidChangeNotification doesn't pass in the previous orientation (or even the new orientation -- you have to get it from UIDevice) the code is essentially making a guess about how it should turn the mirrored view. This guess happens to work fine for all starting positions and turns I usually care about (i.e. portrait and landscape left, and 90° turns from these). 

If you need more, a possible solution is to track the device orientation at -init and across the lifetime of the object, and compute the proper rotation of the view at each device orientation change notification. I didn't need it so I didn't do it, but if someone can contribute it, that would be great.


Mirror Other Apps
-----------------

Adam Curry asked via email if it would be possible to run this in the background (in iOS 4.0) and magically mirror any app running on the device. I tried it, but it didn't work. Seems like the external monitor support switches to whatever app is in the foreground. This is consistent with other apps that play video (i.e. the iPod app, StreamToMe, etc.) so I'm guessing this is just not possible without digging deeper into private APIs.

Get the Code!
-------------



TVOutManager Class Reference
----------------------------

-sharedInstance
Creates a singleton instance (if it doesn't already exist) and returns it. 

-startTVOut
Creates a window on the second screen at the highest resolution it supports, and starts a timer (at the frames per second rate defined in the class file) to copy the screen contents to the window. If no screen is attached, -startTVOut will simply report a failure to the console.

-stopTVOut
Stops the periodic video-mirror timer (or thread) and releases the offscreen window.

tvSafeMode 
When tvSafeMode is YES, the class will scale down the output size by 20%, so that the entire picture can fit within the visible scan area of an analog TV. If you don't know what an analog TV is, don't worry, you'll probably never see one.

kUseBackgroundThread
By default, the class will use an NSTimer to periodically copy the screen display. If you're doing something that blocks the runloop, a background thread may work better for you. Simply change the define to YES and the class will spawn a thread to periodically copy the screen.

define USE_UIGETSCREENIMAGE  
Set to NO to use the App-Store- and Simulator-safe method of capturing the screen. Set to YES to get the highest framerate.


