//
//  metriclock2AppDelegate.m
//  metriclock2
//
//  Created by Patrick Phelan on 12/19/10.
//

#import "metriclock2AppDelegate.h"

#define SecondsInDay 86400

//How many ticks per day
#define Scale 1000

//How many 0 in Scale
#define TimeFmt @"%03d"

//Length of a tick in seconds, SecondsInDay / Scale
#define Tick 86.4

@implementation metriclock2AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	if (_statusItem == nil)
	{

		_statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];

		[self statusInit];

		[_statusItem setTitle: [NSString stringWithFormat: TimeFmt, secs]];
		[_statusItem setHighlightMode:YES];

		NSMenu *menu;
		NSMenuItem *newItem;
		menu = [[NSMenu alloc] initWithTitle:@""];
		newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Quit" action:NULL keyEquivalent:@""];
		[newItem setTarget:self];
		[newItem setAction:@selector(myQuit:)];
		[menu addItem:newItem];
		[newItem release];
		[_statusItem setMenu:menu];
		[menu release];

		[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
															   selector: @selector(receiveWakeNote:) name: NSWorkspaceDidWakeNotification object: NULL];

		timer = [NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)Tick
												 target: self
											   selector: @selector(statusIncr:)
											   userInfo: nil
												repeats: YES
				 ];
	}
}

//setup time
- (void) statusInit {
	//set the current time
	NSCalendarDate *currentDate = [NSCalendarDate calendarDate];
	NSTimeZone *tzoffset = [currentDate timeZone];
	int tzoffsetsecs = [tzoffset secondsFromGMT];

	secs = [currentDate hourOfDay] * 3600 +
	[currentDate minuteOfHour] * 60 +
	[currentDate secondOfMinute];
	//set the timezone to GMT + 12 (Intl date line)
	secs = (secs + tzoffsetsecs + (SecondsInDay/2)) % SecondsInDay;
	secs = (int)(secs / Tick) % Scale;

}

//function for the timer
- (void) statusIncr: (NSTimer*) theTimer {
	if (_statusItem != nil) {
		secs = (secs + 1) % Scale;
		[_statusItem setTitle: [NSString stringWithFormat: TimeFmt, secs]];
	}
}

- (void)myQuit:(id)sender {
#pragma unused (sender)
	[NSApp terminate:self];
	//I'd like it to send the same Quit message that the Default Quit sends, but this works.
	//IB doesn't seem to have access to the code-created Menu item
}

- (NSApplication *)application
{
	return NSApp;
}

- (void) receiveWakeNote: (NSNotification*) note {
	[self statusInit];
	if (_statusItem != nil) {
		[_statusItem setTitle: [NSString stringWithFormat: TimeFmt, secs]];
	}
}

@end
