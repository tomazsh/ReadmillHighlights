//
//  NSString+ReadmillHighlights.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 24/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `NSString (ReadmillHighlights)` category extends `NSString` with custom methods.
 */
@interface NSString (ReadmillHighlights)

///-------------------------
/// @name Pluralized Formats
///-------------------------

/**
 Returns the appropriate pluralizef string given custom count and plural formats.
 
 @param emptyFormat Format to be used when `count` equals `0`.
 @param singularFormat Format to be used when `count` equals `1`.
 @param pluralFormat Format to be used when `count` is greater that `1`.
 @param count Given count.
 @return A `NSString` object.
 */
+ (NSString *)stringWithEmptyFormat:(NSString *)emptyFormat
                     singularFormat:(NSString *)singularFormat
                       pluralFormat:(NSString *)pluralFormat
                              count:(NSUInteger)count;

@end
