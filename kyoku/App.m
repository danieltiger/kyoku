//
//  App.m
//  kyoku
//
//  Created by Arik Devens on 4/10/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

#import "App.h"
#import "iTunes.h"
#import "Track.h"

@interface App()
@property (nonatomic) iTunesApplication *app;
@property (nonatomic) iTunesSource *source;
@end

@implementation App

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.app = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    self.source = [[self.app sources] objectAtIndex:0];

    return self;
}

- (void)play {
    [self.app playpause];
}

- (void)pause {
    [self.app pause];
}

- (void)playPreviousTrack {
    [self.app previousTrack];
}

- (void)playNextTrack {
    [self.app nextTrack];
}

- (void)createPlaylist:(NSString *)playlistName {
    [self deleteRemotePlaylist:playlistName];
    [self createRemotePlaylist:playlistName];
}

- (void)queueTracksForPredicate:(NSPredicate *)predicate onPlaylist:(NSString *)playlistName {
    iTunesPlaylist *sourcePlaylist = [[self.source playlists] objectAtIndex:0];
    iTunesPlaylist *playlist = [[self.source playlists] objectWithName:playlistName];
    if (sourcePlaylist == nil || playlist == nil) { return; }

    NSArray *tracks = [[sourcePlaylist tracks] filteredArrayUsingPredicate:predicate];
    for (iTunesTrack *track in tracks) {
        [track duplicateTo:playlist];
    }
}

- (void)startPlaylist:(NSString *)playlistName {
    iTunesPlaylist *playlist = [[self.source playlists] objectWithName:playlistName];
    if (playlist == nil) { return; }

    [playlist playOnce:true];
}

- (NSArray *)scan {
    NSMutableArray *tracks = [NSMutableArray new];

    iTunesPlaylist *libraryPlaylist = [[self.source playlists] objectAtIndex:0];
    NSArray *libraryTracks = [libraryPlaylist tracks];
    for (iTunesTrack *libraryTrack in libraryTracks) {
        Track *track = [[Track alloc] initWithName:libraryTrack.name
                                            artist:libraryTrack.artist
                                             album:libraryTrack.album];
        [tracks addObject:track];
    }

    return tracks;
}

- (NSString *)infoForPlaylist:(NSString *)playlistName {
    iTunesPlaylist *playlist = [[self.source playlists] objectWithName:playlistName];
    if (playlist == nil) { return @""; }

    NSMutableArray *output = [NSMutableArray array];

    self.app.playerState == iTunesEPlSPlaying ? [output addObject:@"iTunes is playing."] : [output addObject:@"iTunes is not playing."];
    self.app.shuffleEnabled ? [output addObject:@"Shuffling is on."] : [output addObject:@"Shuffling is off."];

    [output addObject:@""];

    iTunesTrack *track = self.app.currentTrack;
    [output addObject:@"Current Track:"];
    [output addObject:[NSString stringWithFormat:@"    %@", track.name]];
    [output addObject:[NSString stringWithFormat:@"    %@", track.artist]];
    [output addObject:[NSString stringWithFormat:@"    %@", track.album]];

    [output addObject:@""];

    int remainingSeconds = (int)(track.duration - self.app.playerPosition) % 60;
    int remainingMinutes = (int)((track.duration - self.app.playerPosition) / 60) % 60;
    NSString *remainingTime = [NSString stringWithFormat:@"%02d:%02d", remainingMinutes, remainingSeconds];

    int barLength = 50;
    int hashes = (int)(self.app.playerPosition/track.duration * barLength);
    int dashes = barLength - hashes;
    NSString *currentBar = [NSString stringWithFormat:@"[%@%@]",
                            [@"" stringByPaddingToLength:hashes withString:@"#" startingAtIndex:0],
                            [@"" stringByPaddingToLength:dashes withString:@"-" startingAtIndex:0]];

    [output addObject:[NSString stringWithFormat:@"%@ -%@", currentBar, remainingTime]];

    return [output componentsJoinedByString:@"\n"];
}

- (NSString *)infoForPlaylistQueue:(NSString *)playlistName {
    iTunesPlaylist *playlist = [[self.source playlists] objectWithName:playlistName];
    if (playlist == nil) { return @""; }

    NSMutableArray *output = [NSMutableArray array];

    iTunesTrack *playing = self.app.currentTrack;
    for (iTunesTrack *track in [playlist tracks]) {
        NSMutableString *entry = [NSMutableString stringWithString:@""];
        [track.name isEqualToString:playing.name] ? [entry appendString:@" > "] : [entry appendString:@"   "];
        [entry appendString:track.name];
        [output addObject:entry];
    }

    return [output componentsJoinedByString:@"\n"];
}


#pragma mark - Helpers

- (void)deleteRemotePlaylist:(NSString *)playlistName {
    iTunesPlaylist *playlist = [[self.source playlists] objectWithName:playlistName];
    if (playlist == nil) { return; }

    [playlist delete];
}

- (void)createRemotePlaylist:(NSString *)playlistName {
    iTunesPlaylist *existingPlaylist = [[[self.source playlists] objectWithName:playlistName] get];
    if (existingPlaylist != nil) { return; }

    NSDictionary *properties = [NSDictionary dictionaryWithObject:playlistName forKey:@"name"];
    iTunesPlaylist *playlist = [[[self.app classForScriptingClass:@"user playlist"] alloc] initWithProperties:properties];
    [[self.source playlists] addObject:playlist];
}

@end
