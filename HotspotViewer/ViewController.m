//
//  ViewController.m
//  HotspotViewer
//
//  Created by Alex Padgett on 3/27/13.
//  Copyright (c) 2013 Alex Padgett. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithImage:(NSImage*)image
{
    self = [super initWithNibName:@"ViewController" bundle:nil];
    if (self) {
        self.image = image;
        self.hotSpots = [[NSMutableArray alloc] initWithCapacity:40];
    }
    
    return self;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void) awakeFromNib
{
    [self.button setFrameSize:self.image.size];
    [self.button setImage:self.image];
    [self.button setImagePosition:NSImageOnly];
    [self.button setBordered:NO];
}

- (IBAction)mouseUp:(id)sender
{
    NSEvent *theEvent = [NSApp currentEvent];
    NSPoint coords = [theEvent locationInWindow];
    NSImageRep *imgRep = self.image.representations[0];
    int imageHeight = (int)[imgRep pixelsHigh];
    int offset = imageHeight - (int) self.view.frame.size.height;
    coords.y = (imageHeight - offset) - coords.y;
    
    int coordX = (int) coords.x;
    int coordY = (int) coords.y;
    [[self.coordForm cellAtIndex:0] setStringValue:[NSString stringWithFormat:@"%i",coordX]];
    [[self.coordForm cellAtIndex:1] setStringValue:[NSString stringWithFormat:@"%i",coordY]];
    
    [self.popover showRelativeToRect:NSMakeRect(coords.x, coords.y, 1.0, 1.0) ofView:self.button preferredEdge:NSMaxYEdge];
    [self.captionField becomeFirstResponder];
}

- (void) clearInputs
{
    [[self.coordForm cellAtIndex:0] setStringValue:@""];
    [[self.coordForm cellAtIndex:1] setStringValue:@""];
    [self.captionField setStringValue:@""];
}

- (IBAction)clickCancel:(id)sender {
    [self.popover close];
    [self clearInputs];
}

- (IBAction)clickOK:(id)sender {
    Hotspot *h = [[Hotspot alloc] init];
    h.x = (NSInteger)[[self.coordForm cellAtIndex:0] integerValue];
    h.y = (NSInteger)[[self.coordForm cellAtIndex:1] integerValue];
    h.caption = [self.captionField stringValue];
    [self.hotSpots addObject:h];
    [self.hsTable reloadData];
    [self.popover close];
    [self clearInputs];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.hotSpots count];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Hotspot *h = [self.hotSpots objectAtIndex:row];
    NSString *columnIdentifier = [tableColumn identifier];
    if ([columnIdentifier isEqual:@"xColumn"]) {
        h.x = (NSInteger)[object integerValue];
    }
    else if ([columnIdentifier isEqual:@"yColumn"])
    {
        h.y = (NSInteger)[object integerValue];
    }
    else if ([columnIdentifier isEqual:@"captionColumn"])
    {
        h.caption = (NSString *)object;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    id returnValue = nil;
    NSString *columnIdentifier = [tableColumn identifier];
    Hotspot *hotspot = [self.hotSpots objectAtIndex:row];
    if ([columnIdentifier isEqual:@"xColumn"]) {
        returnValue = [NSString stringWithFormat:@"%d",(int)hotspot.x];
    }
    else if ([columnIdentifier isEqual:@"yColumn"])
    {
        returnValue = [NSString stringWithFormat:@"%d",(int)hotspot.y];
    }
    else if ([columnIdentifier isEqual:@"captionColumn"])
    {
        returnValue = hotspot.caption;
    }
    return returnValue;
}


@end
