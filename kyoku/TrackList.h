//
//  QueryList.h
//  kyoku
//
//  Created by Arik Devens on 4/8/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

@import Foundation;

@interface TrackList : NSObject

@property (nonatomic, readonly) NSArray *filteredTracks;

- (instancetype)initWithTracks:(NSArray *)tracks predicate:(NSPredicate *)predicate;
- (NSString *)consoleOutput;

@end
