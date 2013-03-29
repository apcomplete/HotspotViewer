//
//  AppDelegate.h
//  HotspotViewer
//
//  Created by Alex Padgett on 3/27/13.
//  Copyright (c) 2013 Alex Padgett. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic,strong) NSView *currentView;
@property (nonatomic,strong) ViewController *viewController;

- (IBAction)openDocument:(id)sender;
- (IBAction)saveDocument:(id)sender;

- (void) exportDocument:(NSURL *)exportPath;

@end
