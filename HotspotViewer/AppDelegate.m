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
    self.scrollView = [[NSScrollView alloc] initWithFrame:[[self.window contentView] frame ]];
    [self.scrollView setHasHorizontalScroller:YES];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setBorderType:NSNoBorder];
    [self.scrollView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [self.viewController.view setFrameSize:[imageToView size]];
    [self.scrollView setDocumentView:self.viewController.view];
    [self.window setContentView:self.scrollView];
    [self.window setFrame:[[NSScreen mainScreen] visibleFrame] display:YES];
}

@end
