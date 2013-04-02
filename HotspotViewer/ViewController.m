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
        self.hotspotIcons = [[NSMutableArray alloc] initWithCapacity:40];
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
    [self.formX setStringValue:[NSString stringWithFormat:@"%i",coordX]];
    [self.formY setStringValue:[NSString stringWithFormat:@"%i",coordY]];
    
    [self.popover showRelativeToRect:NSMakeRect(coords.x, coords.y, 1.0, 1.0) ofView:self.button preferredEdge:NSMaxYEdge];
    [self.captionField becomeFirstResponder];
}

- (void) clearInputs
{
    [self.formX setStringValue:@""];
    [self.formY setStringValue:@""];
    [self.captionField setStringValue:@""];
}

- (void) importHotspots:(NSString *)filePath
{
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    myJSON = [NSString stringWithFormat:@"[%@]",myJSON];
    NSData *jsonData = [myJSON dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    for (NSDictionary *object in json) {
        [self addHotspot:[[object objectForKey:@"x"] integerValue] :[[object objectForKey:@"y"] integerValue] :[object objectForKey:@"body"]];
    }
}

- (IBAction)clickCancel:(id)sender {
    [self.popover close];
    [self clearInputs];
}

- (IBAction)clickOK:(id)sender {
    [self addHotspot: (NSInteger)[self.formX integerValue]: (NSInteger)[self.formY integerValue]:[self.captionField stringValue]];
    [self.popover close];
    [self clearInputs];
}

- (void)addHotspot:(NSInteger)x :(NSInteger)y :(NSString*)caption
{
    Hotspot *h = [[Hotspot alloc] init];
    h.x = x;
    h.y = y;
    h.caption = caption;
    NSImageRep *imgRep = self.image.representations[0];
    int imageHeight = (int)[imgRep pixelsHigh];
    NSInteger trueY = imageHeight - y;
    [self.hotSpots addObject:h];
    [self.hsTable reloadData];
    NSButton *iconButton = [[NSButton alloc] initWithFrame:NSMakeRect(x, trueY, 20, 20)];
    [iconButton setButtonType:NSMomentaryChangeButton];
    [iconButton setImage:[NSImage imageNamed:@"target.png"]];
    [iconButton setImagePosition:NSImageOnly];
    [iconButton setBordered:NO];
    [iconButton setAutoresizesSubviews:YES];
    [iconButton setAction:@selector(highlightRow:)];
    [iconButton setTarget:self];
    [self.view addSubview:iconButton];
    [self.hotspotIcons addObject:iconButton];
}

- (void)highlightRow:(id)sender
{
    NSInteger row = [self.hotspotIcons indexOfObject:sender];
    [self.hsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
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
    NSImageRep *imgRep = self.image.representations[0];
    int imageHeight = (int)[imgRep pixelsHigh];
    NSInteger trueY = imageHeight - h.y;
    [[self.hotspotIcons objectAtIndex:row] setFrame:NSMakeRect(h.x, trueY, 20, 20)];
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
