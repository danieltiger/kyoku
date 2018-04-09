//
//  App.m
//  kyoku
//
//  Created by Arik Devens on 4/8/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

#import "Kyoku.h"
#import "TrackList.h"
#import "Playlist.h"

@interface Kyoku()
@property (nonatomic) iTunesApplication *app;
@property (nonatomic) iTunesSource *library;
@property (nonatomic) iTunesPlaylist *libraryPlaylist;
@end

@implementation Kyoku

- (void)run {
    self.app = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    self.library = [[self.app sources] objectAtIndex:0];
    self.libraryPlaylist = [[self.library playlists] objectAtIndex:0];

    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    if (arguments.count < 2) {
        [self printUsage];
        [self printToConsole:@""];
        [self listInfo];
        return;
    }

    [self performActionForArguments:[arguments subarrayWithRange:NSMakeRange(1, [arguments count] - 1)]];
}


#pragma mark - Helpers

- (void)performActionForArguments:(NSArray *)arguments {
    NSString *verb = arguments.firstObject;
    NSString *noun = arguments.lastObject;

    if ([verb isEqualToString:@"list"]) {
        [self listForNoun:noun];
    } else if ([verb isEqualToString:@"song"]) {
        [self playForModifier:@"name" noun:noun];
    } else if ([verb isEqualToString:@"album"]) {
        [self playForModifier:@"album" noun:noun];
    } else if ([verb hasPrefix:@"prev"]) {
        [self.app previousTrack];
    } else if ([verb hasPrefix:@"next"]) {
        [self.app nextTrack];
    } else if ([verb hasPrefix:@"play"]) {
        [self.app playpause];
    } else if ([verb hasPrefix:@"pause"]) {
        [self.app pause];
    } else if ([verb isEqualToString:@"list-queue"]) {
        [self listQueue];
    } else if ([verb isEqualToString:@"info"]) {
        [self listInfo];
    } else if ([verb isEqualToString:@"queue"]) {
        NSString *modifier = arguments[1];
        if ([modifier isEqualToString:@"song"]) {
            [self queueForModifier:modifier noun:noun];
        } else if ([modifier isEqualToString:@"album"]) {
            [self queueForModifier:modifier noun:noun];
        }
    } else {
        [self printUsage];
        [self listInfo];
    }
}

- (void)printUsage {
    printf("usage: kyoku command [<query>]\n");
    printf("\n");
    printf("The following commands are supported:\n");
    printf("   list          List all songs, artists, or albums that match the query string\n");
    printf("   song          Play all songs that match the query string\n");
    printf("   album         Play all albums that match the query string\n");
    printf("   queue song    Queue all songs that match the query string\n");
    printf("   queue album   Queue all albums that match the query string\n");
    printf("   previous      Play the previous track in the playlist\n");
    printf("   next          Play the next track in the playlist\n");
    printf("   play          Either start playback, or pause if playback is already started\n");
    printf("   pause         Pause playback\n");
    printf("   list-queue    Show the current playlist, marking the current track\n");
    printf("   info          Show track information\n");
}

- (void)printToConsole:(NSString *)message {
    printf("%s\n", [message UTF8String]);
}

- (void)listForNoun:(NSString *)noun {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ OR artist contains %@ OR album contains %@", noun, noun, noun];
    TrackList *trackList = [[TrackList alloc] initWithTracks:[self.libraryPlaylist tracks] predicate:predicate];
    [self printToConsole:[trackList consoleOutput]];
}

- (void)playForModifier:(NSString *)modifier noun:(NSString *)noun {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains %@", modifier, noun];
    TrackList *trackList = [[TrackList alloc] initWithTracks:[self.libraryPlaylist tracks] predicate:predicate];
    Playlist *playlist = [[Playlist alloc] initWithApplication:self.app];
    [playlist regenerate];
    [playlist queueTracks:[trackList filteredTracks]];
    [playlist play];
}

- (void)listQueue {
    Playlist *playlist = [[Playlist alloc] initWithApplication:self.app];
    [self printToConsole:[playlist consoleQueueOutput]];
}

- (void)listInfo {
    Playlist *playlist = [[Playlist alloc] initWithApplication:self.app];
    [self printToConsole:[playlist consoleInfoOutput]];
}

- (void)queueForModifier:(NSString *)modifier noun:(NSString *)noun {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains %@", modifier, noun];
    TrackList *trackList = [[TrackList alloc] initWithTracks:[self.libraryPlaylist tracks] predicate:predicate];
    Playlist *playlist = [[Playlist alloc] initWithApplication:self.app];
    [playlist queueTracks:[trackList filteredTracks]];
}

@end
