//
//  ReadmillHighlightsAppDelegate.m
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 21/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import "ReadmillHighlightsAppDelegate.h"
#import "ReadmillHighlightsViewController.h"
#import "ReadmillHighlightsConfiguration.h"
#import "UIAlertView+ReadmillHighlights.h"
#import "ReadmillUser+ReadmillHighlights.h"

@implementation ReadmillHighlightsAppDelegate
@synthesize redirectURL = _redirectURL;
@synthesize apiConfiguration = _apiConfiguration;

#pragma mark -
#pragma mark Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            nil, ReadmillHighlightsUserCredentialsKey, nil]];
    
    // Setup UI.
    self.highlightsViewController = [ReadmillHighlightsViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.highlightsViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    // Check for saved credentials.
    id credentials = [[NSUserDefaults standardUserDefaults] objectForKey:ReadmillHighlightsUserCredentialsKey];
    if (credentials) {
        [ReadmillUser authenticateWithPropertyListRepresentation:credentials delegate:self];
    } else {
        NSURL *url = [ReadmillUser clientAuthorizationURLWithRedirectURL:self.redirectURL apiConfiguration:self.apiConfiguration];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    // Override some appearances.
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f], UITextAttributeFont, nil]];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:1.0f forBarMetrics:UIBarMetricsDefault];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // Check if we were redirected back to the app by Readmill OAuth.
    [ReadmillUser authenticateCallbackURL:url baseCallbackURL:self.redirectURL delegate:self apiConfiguration:[self apiConfiguration]];
    return YES;
}

#pragma mark -
#pragma mark Properties

- (NSURL *)redirectURL
{
    if (!_redirectURL) {
        _redirectURL = [NSURL URLWithString:ReadmillHighlightsRedirectURLString];
    }
    return _redirectURL;
}

- (ReadmillAPIConfiguration *)apiConfiguration
{
    if (!_apiConfiguration) {
        _apiConfiguration = [ReadmillAPIConfiguration configurationForProductionWithClientID:ReadmillHighlightsClientId clientSecret:ReadmillHighlightsClientSecret redirectURL:self.redirectURL];
    }
    return _apiConfiguration;
}

#pragma mark -
#pragma mark ReadmillUserAuthenticationDelegate

- (void)readmillAuthenticationDidSucceedWithLoggedInUser:(ReadmillUser *)loggedInUser
{
    // Set the current user and load highlights.
    [ReadmillUser setCurrentUser:loggedInUser];
    [self.highlightsViewController loadHighlights:self];
}

- (void)readmillAuthenticationDidFailWithError:(NSError *)authenticationError
{
    // Handle authentication error.
    if (authenticationError.code == 401) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:ReadmillHighlightsUserCredentialsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [UIAlertView showError:authenticationError withTitle:NSLocalizedString(@"Authentication Error", nil) cancelButtonTitle:NSLocalizedString(@"OK", nil)];
}

@end
