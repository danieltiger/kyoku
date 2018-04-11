//
//  App.h
//  kyoku
//
//  Created by Arik Devens on 4/10/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

@import Foundation;

@interface App : NSObject

- (void)play;
- (void)pause;
- (void)playPreviousTrack;
- (void)playNextTrack;
- (void)createPlaylist:(NSString *)playlistName;
- (void)queueTracksForPredicate:(NSPredicate *)predicate onPlaylist:(NSString *)playlistName;
- (void)startPlaylist:(NSString *)playlistName;
- (NSArray *)scan;
- (NSString *)infoForPlaylist:(NSString *)playlistName;
- (NSString *)infoForPlaylistQueue:(NSString *)playlistName;

@end
