
//
//  Store.m
//  kyoku
//
//  Created by Arik Devens on 4/10/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

#import "Store.h"

@implementation Store

+ (BOOL)storeExists {
    return [[NSFileManager defaultManager] fileExistsAtPath:[Store filePath]];
}

+ (Library *)readLibraryFromStore {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Store filePath]];
}

+ (void)writeLibraryToStore:(Library *)library {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;

    NSString *directoryPath = [Store directoryPath];
    NSString *filePath = [Store filePath];
    [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    [fileManager removeItemAtPath:filePath error:&error];
    [NSKeyedArchiver archiveRootObject:library toFile:filePath];

    if (error) NSLog(@"%@", error);
}


#pragma mark - Helpers

+ (NSString *)directoryPath {
    return [NSString stringWithFormat:@"%@/.kyoku", NSHomeDirectory()];
}

+ (NSString *)filePath {
    return [[Store directoryPath] stringByAppendingString:@"/library"];
}

@end
