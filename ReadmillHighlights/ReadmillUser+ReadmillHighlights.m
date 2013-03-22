//
//  ReadmillUser+ReadmillHighlights.m
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import "ReadmillUser+ReadmillHighlights.h"
#import "ReadmillHighlightsConfiguration.h"

static void *ReadmillHighlightsUserStorePropertyCurrentUserObservingContext = &ReadmillHighlightsUserStorePropertyCurrentUserObservingContext;

/**
 A simple to store users. Could be modified to support multiple accounts depending on needs. Usable through `sharedUserStore` singleton.
 */
@interface ReadmillHighlightsUserStore : NSObject

/**
 Currently logged in user.
 */
@property(nonatomic) ReadmillUser *currentUser;

/**
 Shared user store.
 
 @return A singleton instance of the shared user store.
 */
+ (id)sharedUserStore;

@end

@implementation ReadmillHighlightsUserStore
@synthesize currentUser = _currentUser;

+ (id)sharedUserStore
{
    static ReadmillHighlightsUserStore *User = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        User = [ReadmillHighlightsUserStore new];
    });
    return User;
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"propertyListRepresentation"] && object == _currentUser && context == ReadmillHighlightsUserStorePropertyCurrentUserObservingContext) {
        if (self.currentUser.propertyListRepresentation) {
            [[NSUserDefaults standardUserDefaults] setValue:self.currentUser.propertyListRepresentation forKey:ReadmillHighlightsUserCredentialsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark -
#pragma mark Properties

- (void)setCurrentUser:(ReadmillUser *)currentUser
{
    // Set the current user and observe for credential changes.
    _currentUser = currentUser;
    if (_currentUser) {
        [_currentUser addObserver:self forKeyPath:@"propertyListRepresentation" options:NSKeyValueObservingOptionInitial context:ReadmillHighlightsUserStorePropertyCurrentUserObservingContext];
    } else {
        [_currentUser removeObserver:self forKeyPath:@"propertyListRepresentation" context:ReadmillHighlightsUserStorePropertyCurrentUserObservingContext];
    }
}

@end

#pragma mark -

@implementation ReadmillUser (ReadmillHighlightsUser)

+ (ReadmillUser *)currentUser
{
    return [[ReadmillHighlightsUserStore sharedUserStore] currentUser];
}

+ (void)setCurrentUser:(ReadmillUser *)user
{
    [[ReadmillHighlightsUserStore sharedUserStore] setCurrentUser:user];
}

@end
