//
//  UIAlertView+ReadmillHighlights.m
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import "UIAlertView+ReadmillHighlights.h"

@implementation UIAlertView (ReadmillHighlights)

#pragma mark -
#pragma mark Class Methods

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    UIAlertView *alertView = [[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alertView show];
}

+ (void)showError:(NSError *)error withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle
{
    [self showAlertWithTitle:title message:[error localizedDescription] cancelButtonTitle:cancelButtonTitle];
}

@end
