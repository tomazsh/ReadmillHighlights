//
//  NSString+ReadmillHighlights.m
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 24/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import "NSString+ReadmillHighlights.h"

@implementation NSString (ReadmillHighlights)

#pragma mark -
#pragma mark Class Methods

+ (NSString *)stringWithEmptyFormat:(NSString *)emptyFormat singularFormat:(NSString *)singularFormat pluralFormat:(NSString *)pluralFormat count:(NSUInteger)count
{
    switch (count) {
        case 0:
            return [self stringWithFormat:emptyFormat, count];
        case 1:
            return [self stringWithFormat:singularFormat, count];
        default:
            return [self stringWithFormat:pluralFormat, count];
    }
}

@end
