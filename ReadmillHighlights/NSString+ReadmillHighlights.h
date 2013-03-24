//
//  NSString+ReadmillHighlights.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 24/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ReadmillHighlights)

+ (NSString *)stringWithEmptyFormat:(NSString *)emptyFormat
                     singularFormat:(NSString *)singularFormat
                       pluralFormat:(NSString *)pluralFormat
                              count:(NSUInteger)count;

@end
