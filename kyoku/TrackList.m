//
//  QueryList.m
//  kyoku
//
//  Created by Arik Devens on 4/8/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

#import "TrackList.h"
#import "iTunes.h"

@interface TrackList()
@property (nonatomic, readwrite) NSArray *filteredTracks;
@end

@implementation TrackList

#pragma mark - Create/Destroy

- (instancetype)initWithTracks:(NSArray *)tracks predicate:(NSPredicate *)predicate {
    self = [super init];
    if (!self) return nil;

    self.filteredTracks = [tracks filteredArrayUsingPredicate:predicate];

    return self;
}


#pragma mark - API

- (NSString *)consoleOutput {
    NSInteger songLength = 0;
    NSInteger artistLength = 0;
    NSInteger albumLength = 0;
    for (iTunesTrack *track in self.filteredTracks) {
        if (track.name.length > songLength) {
            songLength = track.name.length + 1;
        }
        if (track.artist.length > artistLength) {
            artistLength = track.artist.length + 1;
        }
        if (track.album.length > albumLength) {
            albumLength = track.album.length + 1;
        }
    }

    NSMutableArray *output = [NSMutableArray array];

    [output addObject:@"Here are the results:"];
    [output addObject:[self headerStringWithSongLength:songLength artistLength:artistLength albumLength:albumLength]];
    [output addObject:[self dividerStringWithSongLength:songLength artistLength:artistLength albumLength:albumLength]];

    for (iTunesTrack *track in self.filteredTracks) {
        [output addObject:[self entryStringWithTrack:track songLength:songLength artistLength:artistLength albumLength:albumLength]];
    }

    return [output componentsJoinedByString:@"\n"];
}


#pragma mark - Helpers

- (NSString *)headerStringWithSongLength:(NSInteger)songLength artistLength:(NSInteger)artistLength albumLength:(NSInteger)albumLength {
    NSMutableArray *header = [NSMutableArray array];

    [header addObject:@"| "];
    [header addObject:[@"name" stringByPaddingToLength:songLength withString:@" " startingAtIndex:0]];
    [header addObject:@"| "];
    [header addObject:[@"artist" stringByPaddingToLength:artistLength withString:@" " startingAtIndex:0]];
    [header addObject:@"| "];
    [header addObject:[@"album" stringByPaddingToLength:albumLength withString:@" " startingAtIndex:0]];
    [header addObject:@"|"];

    return [header componentsJoinedByString:@""];
}

- (NSString *)dividerStringWithSongLength:(NSInteger)songLength artistLength:(NSInteger)artistLength albumLength:(NSInteger)albumLength {
    NSMutableArray *divider = [NSMutableArray array];

    [divider addObject:@"| "];
    [divider addObject:[@"" stringByPaddingToLength:songLength withString:@"-" startingAtIndex:0]];
    [divider addObject:@"| "];
    [divider addObject:[@"" stringByPaddingToLength:artistLength withString:@"-" startingAtIndex:0]];
    [divider addObject:@"| "];
    [divider addObject:[@"" stringByPaddingToLength:albumLength withString:@"-" startingAtIndex:0]];
    [divider addObject:@"|"];

    return [divider componentsJoinedByString:@""];
}

- (NSString *)entryStringWithTrack:(iTunesTrack *)track songLength:(NSInteger)songLength artistLength:(NSInteger)artistLength albumLength:(NSInteger)albumLength {
    NSMutableArray *entry = [NSMutableArray array];

    [entry addObject:@"| "];
    [entry addObject:[track.name stringByPaddingToLength:songLength withString:@" " startingAtIndex:0]];
    [entry addObject:@"| "];
    [entry addObject:[track.artist stringByPaddingToLength:artistLength withString:@" " startingAtIndex:0]];
    [entry addObject:@"| "];
    [entry addObject:[track.album stringByPaddingToLength:albumLength withString:@" " startingAtIndex:0]];
    [entry addObject:@"|"];

    return [entry componentsJoinedByString:@""];
}

@end
