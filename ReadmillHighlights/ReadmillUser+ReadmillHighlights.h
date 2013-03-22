//
//  ReadmillUser+ReadmillHighlights.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `ReadmillUser (ReadmillHighlights)` category aims to simplify current user access.
 */
@interface ReadmillUser (ReadmillHighlights)

///-----------------------------
/// @name Accessing Current User
///-----------------------------

/**
 Returns currently logged in user.
 
 @return A `ReadmillUser` instance or `nil` if the current user has not ben set.
 */
+ (ReadmillUser *)currentUser;

/**
 Sets the currently logged in user.
 
 @param user A `ReadmillUser` instance to be set as the current user.
 */
+ (void)setCurrentUser:(ReadmillUser *)user;

@end
