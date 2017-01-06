//
//  metriclock2AppDelegate.h
//  metriclock2
//
//  Created by Patrick Phelan on 12/19/10.
//

#import <Cocoa/Cocoa.h>

@interface metriclock2AppDelegate : NSObject <NSApplicationDelegate> {
	NSStatusItem		*_statusItem;
	NSTimer * timer;
	int secs;
}

//@property (retain) NSTimer * timer;

- (void)statusInit;
- (void)statusIncr: (NSTimer*) theTimer;
- (id)statusItem;
- (void)myQuit:(id)sender;
- (NSApplication *)application;
- (void) receiveWakeNote: (NSNotification*) note;


@end
