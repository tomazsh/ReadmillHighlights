//
//  ReadmillHighlightsViewController.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The ReadmillHighlightsViewController manages presentation of highlights list.
 */
@interface ReadmillHighlightsViewController : UITableViewController <ReadmillHighlightsFindingDelegate>

///-------------------------
/// @name Loading Highlights
///-------------------------

/**
 Loads the first 100 highlights and displays them.
 
 @param sender Object that initiated the load.
 */
- (void)loadHighlights:(id)sender;

@end
