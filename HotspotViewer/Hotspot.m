//
//  Hotspot.m
//  HotspotViewer
//
//  Created by Alex Padgett on 3/28/13.
//  Copyright (c) 2013 Alex Padgett. All rights reserved.
//

#import "Hotspot.h"

@implementation Hotspot

- (NSString *) toJSON{
    NSDictionary *data = @{@"x": @(self.x), @"y":@(self.y),@"caption":self.caption};
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end
