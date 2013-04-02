//
//  ViewController.h
//  HotspotViewer
//
//  Created by Alex Padgett on 3/27/13.
//  Copyright (c) 2013 Alex Padgett. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "Hotspot.h"

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

- (id)initWithImage:(NSImage *)image;

@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,strong) NSImage *image;
@property (nonatomic,strong) NSMutableArray *hotSpots;
@property (nonatomic,strong) NSMutableArray *hotspotIcons;

- (IBAction) mouseUp:(id)sender;

@property (weak) IBOutlet NSButton *button;
@property (weak) IBOutlet NSPopover *popover;
@property (weak) IBOutlet NSTextField *captionField;
@property (weak) IBOutlet NSTableView *hsTable;
@property (weak) IBOutlet NSFormCell *formX;
@property (weak) IBOutlet NSFormCell *formY;

- (void) clearInputs;
- (void) importHotspots:(NSString *)filePath;
- (void) addHotspot:(NSInteger)x :(NSInteger)y :(NSString*)caption;

//table methods
- (void) highlightRow:(id)sender;
- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView;
- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
@end
