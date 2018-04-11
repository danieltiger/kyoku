//
//  Track.m
//  kyoku
//
//  Created by Arik Devens on 4/10/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

#import "Track.h"

@interface Track()
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *artist;
@property (nonatomic, readwrite) NSString *album;
@end

@implementation Track

- (instancetype)initWithName:(NSString *)name artist:(NSString *)artist album:(NSString *)album {
    self = [super init];
    if (!self) return nil;

    _name = name;
    _artist = artist;
    _album = album;

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) return nil;

    self.name = [decoder decodeObjectForKey:@"name"];
    self.artist = [decoder decodeObjectForKey:@"artist"];
    self.album = [decoder decodeObjectForKey:@"album"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.artist forKey:@"artist"];
    [encoder encodeObject:self.album forKey:@"album"];
}

@end
