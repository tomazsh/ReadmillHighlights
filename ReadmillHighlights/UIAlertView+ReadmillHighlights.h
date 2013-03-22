//
//  UIAlertView+ReadmillHighlights.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The `UIAlertView(ReadmillHighlights)` protocol extends `UIAlertView`.
 */
@interface UIAlertView (ReadmillHighlights)

///------------------------
/// @name Displaying Alerts
///------------------------

/**
 Creates a new alert view with supplied parameters and displays it.
 
 @param title The string that appears in the receiver’s title bar.
 @param message Descriptive text that provides more details than the title.
 @param cancelButtonTitle The title of the cancel button or nil if there is no cancel button.
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle;

/**
 Creates a new alert view with supplied parameters and displays it.
 
 @param error Error to use for the alert view message.
 @param title The string that appears in the receiver’s title bar.
 @param cancelButtonTitle The title of the cancel button or nil if there is no cancel button.
 */
+ (void)showError:(NSError *)error
        withTitle:(NSString *)title
cancelButtonTitle:(NSString *)cancelButtonTitle;

@end
