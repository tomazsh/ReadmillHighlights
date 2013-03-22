//
//  ReadmillHighlightsAppDelegate.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 21/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReadmillHighlightsViewController;

@interface ReadmillHighlightsAppDelegate : UIResponder <UIApplicationDelegate, ReadmillUserAuthenticationDelegate>

@property(readonly, nonatomic) NSURL *redirectURL;
@property(readonly, nonatomic) ReadmillAPIConfiguration *apiConfiguration;

@property(nonatomic) UIWindow *window;
@property(nonatomic) ReadmillHighlightsViewController *highlightsViewController;

@end
