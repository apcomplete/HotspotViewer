//
//  AppDelegate.m
//  HotspotViewer
//
//  Created by Alex Padgett on 3/27/13.
//  Copyright (c) 2013 Alex Padgett. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (IBAction)openDocument:(id)sender {
    NSOpenPanel *openImagePanel = [NSOpenPanel openPanel];
    openImagePanel.allowsMultipleSelection = false;
    [openImagePanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSArray *files = [openImagePanel URLs];
            NSURL *imageDirectory = [files objectAtIndex:0];
            [self openNewDialog:imageDirectory];
            [self.window makeKeyAndOrderFront:self];
        }
    }];
}

- (IBAction)saveDocument:(id)sender {
    // Build a new name for the file using the current name and
    // the filename extension associated with the specified UTI.
    NSString* newName = [self.viewController.image.name stringByAppendingPathExtension:@"json"];
    
    // Set the default name for the file and show the panel.
    NSSavePanel*    panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:newName];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            [self exportDocument:[panel URL]];
        }
    }];
}

- (void)exportDocument:(NSURL *)exportPath
{
    NSMutableArray *outputArray = [[NSMutableArray alloc] initWithCapacity:[self.viewController.hotSpots count]];
    NSError *writeError = nil;
    for (Hotspot *h in self.viewController.hotSpots) {
        NSString *jsonData = [h toJSON];
        [outputArray addObject:jsonData];
    }
    [[outputArray componentsJoinedByString:@",\n"] writeToURL:exportPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
}
- (void) openNewDialog:(NSURL *)imageURL
{
    if (self.currentView != nil) {
        [self.currentView removeFromSuperview];
    }
    NSString *imagePath = [imageURL path];
    NSImageRep *imgRep = [NSImageRep imageRepWithContentsOfFile:imagePath];
    int imageWidth = (int)[imgRep pixelsWide];
    int imageHeight = (int)[imgRep pixelsHigh];
    NSImage *imageToView = [[NSImage alloc] initWithSize:NSMakeSize((CGFloat)imageWidth,(CGFloat)imageHeight)];
    [imageToView addRepresentation:imgRep];
    [imageToView setName:[[imagePath lastPathComponent] stringByDeletingPathExtension]];
    self.viewController = [[ViewController alloc] initWithImage:imageToView];
    
    NSString *jsonFile = [[imagePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"json"];
    bool b=[[NSFileManager defaultManager] fileExistsAtPath:jsonFile];
    if (b) {
        [self.viewController importHotspots:jsonFile];
    }
    self.currentView = self.viewController.view;
    [self.window.contentView addSubview:self.viewController.view];
    [self.window setFrame:[NSWindow frameRectForContentRect:
                        NSMakeRect([self.window frame].origin.x,
                                   [self.window frame].origin.y,
                                   imageWidth,
                                   imageHeight)
                                               styleMask: [self.window styleMask]
                        ]
               display:YES
               animate:YES];
    self.viewController.view.frame = ((NSView *)self.window.contentView).bounds;
}

@end
