//
//  Playlist.m
//  kyoku
//
//  Created by Arik Devens on 4/8/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

#import "Playlist.h"

@interface Playlist()
@property (nonatomic) iTunesApplication *app;
@property (nonatomic) iTunesSource *library;
@property (nonatomic) iTunesPlaylist *playlist;
@property (nonatomic) NSString *name;
@end

@implementation Playlist

- (instancetype)initWithApplication:(iTunesApplication *)application {
    self = [super init];
    if (!self) return nil;

    self.app = application;
    self.library = [[self.app sources] objectAtIndex:0];
    self.name = @"Kyoku";

    return self;
}

- (void)queueTracks:(NSArray *)tracks {
    iTunesPlaylist *playlist = [[self.library playlists] objectWithName:self.name];
    if (playlist == nil) { return; }

    for (iTunesTrack *track in tracks) {
        [track duplicateTo:playlist];
    }
}

- (void)regenerate {
    [self deleteRemotePlaylist];
    [self newRemotePlaylist];
}

- (void)play {
    iTunesPlaylist *playlist = [[self.library playlists] objectWithName:self.name];
    if (playlist == nil) { return; }

    [playlist playOnce:true];
}

- (NSString *)consoleQueueOutput {
    iTunesPlaylist *playlist = [[self.library playlists] objectWithName:self.name];
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

- (NSString *)consoleInfoOutput {
    iTunesPlaylist *playlist = [[self.library playlists] objectWithName:self.name];
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


#pragma mark - Helpers

- (void)deleteRemotePlaylist {
    iTunesPlaylist *playlist = [[self.library playlists] objectWithName:self.name];
    if (playlist == nil) { return; }

    [playlist delete];
}

- (void)newRemotePlaylist {
    iTunesPlaylist *existingPlaylist = [[[self.library playlists] objectWithName:self.name] get];
    if (existingPlaylist != nil) { return; }

    NSDictionary *properties = [NSDictionary dictionaryWithObject:self.name forKey:@"name"];
    iTunesPlaylist *playlist = [[[self.app classForScriptingClass:@"user playlist"] alloc] initWithProperties:properties];
    [[self.library playlists] addObject:playlist];
}

@end
