//
//  ReadmillHighlightsAppDelegate.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 21/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReadmillHighlightsViewController;

/**
 The ReadmillHighlightsAppDelegate app delegate
 */
@interface ReadmillHighlightsAppDelegate : UIResponder <UIApplicationDelegate, ReadmillUserAuthenticationDelegate>

/**
 Redirect URL for the OAuth authentication.
 */
@property(readonly, nonatomic) NSURL *redirectURL;

/**
 Readmill API configuration.
 */
@property(readonly, nonatomic) ReadmillAPIConfiguration *apiConfiguration;

/**
 Application's key window.
 */
@property(nonatomic) UIWindow *window;

/**
 A `ReadmillHighlightsViewController` instance that represents the root view controller.
 */
@property(nonatomic) ReadmillHighlightsViewController *highlightsViewController;

@end
