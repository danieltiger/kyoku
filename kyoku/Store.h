//
//  Store.h
//  kyoku
//
//  Created by Arik Devens on 4/10/18.
//  Copyright © 2018 danieltiger. All rights reserved.
//

@import Foundation;
#import "Library.h"

@interface Store : NSObject

+ (BOOL)storeExists;
+ (Library *)readLibraryFromStore;
+ (void)writeLibraryToStore:(Library *)library;

@end
