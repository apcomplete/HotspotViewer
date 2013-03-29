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

@property (weak) IBOutlet NSButton *button;
@property (strong) IBOutlet NSPopover *popover;

- (IBAction)mouseUp:(id)sender;

@property (weak) IBOutlet NSForm *coordForm;
@property (weak) IBOutlet NSTextField *captionField;
@property (weak) IBOutlet NSTableView *hsTable;

- (void) clearInputs;
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
@end
