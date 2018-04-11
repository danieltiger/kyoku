//
//  Library.h
//  kyoku
//
//  Created by Arik Devens on 4/10/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

@import Foundation;

@interface Library : NSObject

- (instancetype)initWithTracks:(NSArray *)tracks;
- (instancetype)filteredListWithPredicate:(NSPredicate *)predicate;

- (NSString *)consoleOutput;

@end
