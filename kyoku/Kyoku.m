//
//  App.m
//  kyoku
//
//  Created by Arik Devens on 4/8/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

#import "Kyoku.h"
#import "App.h"
#import "Store.h"
#import "Library.h"

NSString *AppPlaylistName = @"Kyoku";

@interface Kyoku()
@property (nonatomic) App *app;
@property (nonatomic) Library *library;
@end

@implementation Kyoku

- (void)run {
    self.app = [App new];

    if ([Store storeExists]) {
        self.library = [Store readLibraryFromStore];
    }

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
        [self.app playPreviousTrack];
    } else if ([verb hasPrefix:@"next"]) {
        [self.app playNextTrack];
    } else if ([verb hasPrefix:@"play"]) {
        [self.app play];
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
    } else if ([verb isEqualToString:@"scan"]) {
        [self scan];
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
    printf("   scan          Scan the files in iTunes and store locally for searching\n");
}

- (void)printToConsole:(NSString *)message {
    printf("%s\n", [message UTF8String]);
}

- (void)listForNoun:(NSString *)noun {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@ OR artist contains[cd] %@ OR album contains[cd] %@", noun, noun, noun];
    Library *filteredLibrary = [self.library filteredListWithPredicate:predicate];
    [self printToConsole:[filteredLibrary consoleOutput]];
}

- (void)playForModifier:(NSString *)modifier noun:(NSString *)noun {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", modifier, noun];
    [self.app createPlaylist:AppPlaylistName];
    [self.app queueTracksForPredicate:predicate onPlaylist:AppPlaylistName];
    [self.app startPlaylist:AppPlaylistName];
}

- (void)listQueue {
    [self printToConsole:[self.app infoForPlaylistQueue:AppPlaylistName]];
}

- (void)listInfo {
    [self printToConsole:[self.app infoForPlaylist:AppPlaylistName]];
}

- (void)queueForModifier:(NSString *)modifier noun:(NSString *)noun {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", modifier, noun];
    [self.app queueTracksForPredicate:predicate onPlaylist:AppPlaylistName];
}

- (void)scan {
    NSArray *tracks = [self.app scan];
    Library *library = [[Library alloc] initWithTracks:tracks];
    [Store writeLibraryToStore:library];
}

@end
