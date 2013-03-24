//
//  UIImageView+ReadmillHighlights.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 24/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Completion block to be executed at the end of retrieving image from the network. This block has no return type and takes three parameters: a `NSURLResponse` object, a `UIImage` object or `nil` if there is none, and a `NSError` object if an error occured while retrieving image.
 */
typedef void(^ReadmillHighlightsNetworkImageCompletionHandler)(NSURLResponse *, UIImage *, NSError *);

@interface UIImageView (ReadmillHighlights)

/**
 Sets an image to the receiver for a specified network URL.
 
 @param imageURL The URL of an image to be set.
 @param completionHandler The `ReadmillHighlightsNetworkImageCompletionBlock` handler to be executed at the completion.
 @discussion This method doesn+ not work with file system URLs yet.
 */
- (void)setImageWithURL:(NSURL *)imageURL completionHandler:(ReadmillHighlightsNetworkImageCompletionHandler)completionHandler;

@end
