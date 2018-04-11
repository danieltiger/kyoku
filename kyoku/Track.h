//
//  Track.h
//  kyoku
//
//  Created by Arik Devens on 4/10/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

@import Foundation;

@interface Track : NSObject<NSCoding>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *artist;
@property (nonatomic, readonly) NSString *album;

- (instancetype)initWithName:(NSString *)name artist:(NSString *)artist album:(NSString *)album;

@end
