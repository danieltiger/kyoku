//
//  Playlist.h
//  kyoku
//
//  Created by Arik Devens on 4/8/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

@import Foundation;
#import "iTunes.h"

@interface Playlist : NSObject

- (instancetype)initWithApplication:(iTunesApplication *)application;

- (void)queueTracks:(NSArray *)tracks;
- (void)regenerate;
- (void)play;

- (NSString *)consoleQueueOutput;
- (NSString *)consoleInfoOutput;

@end
