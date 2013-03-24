//
//  ReadmillHighlightViewController.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Inset of the highlight's content.
 */
extern UIEdgeInsets const ReadmillHighlightViewControllerHighlightContentInset;

/**
 The `ReadmillHighlightViewController` manages presentation of a single highlight and its comments.
 */
@interface ReadmillHighlightViewController : UITableViewController <ReadmillCommentsFindingDelegate>

@property(nonatomic) ReadmillHighlight *highlight;

///-----------------------
/// @name Loading Comments
///-----------------------

/**
 Loads the first 100 comments for `highlight` and displays them.
 
 @param sender Object that initiated the load.
 */
- (void)loadComments:(id)sender;

@end
