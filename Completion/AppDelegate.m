//
//  AppDelegate.m
//  Completion
//
//  Created by Andrey M on 15.10.14.
//  Copyright (c) 2014 Andrey M. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    self.popover.behavior = NSPopoverBehaviorTransient;
    
    self.itemsList = [NSMutableArray arrayWithObjects: @{@"title": @"Item 1"}, @{@"title": @"Item 2"}, @{@"title": @"Item 3"}, @{@"title": @"Item 4"}, nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
