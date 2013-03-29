//
//  Hotspot.h
//  HotspotViewer
//
//  Created by Alex Padgett on 3/28/13.
//  Copyright (c) 2013 Alex Padgett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hotspot : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, retain) NSString *caption;

- (NSString *) toJSON;
@end
