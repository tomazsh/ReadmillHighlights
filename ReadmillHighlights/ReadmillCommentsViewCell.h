//
//  ReadmillCommentsViewCell.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 24/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Size for the image view.
 */
extern CGSize const ReadmillCommentsViewCellImageSize;

/**
 Content inset for the cell.
 */
extern UIEdgeInsets const ReadmillCommentsViewCellContentInset;

/**
 Content spacing base proportion for cell views.
 */
extern CGFloat const ReadmillCommentsViewCellContentSpacing;

/**
 The `ReadmillCommentsViewCell` is used to display a single comment in the list.
 */
@interface ReadmillCommentsViewCell : UITableViewCell

/**
 Label to display the comment's content.
 */
@property(readonly, nonatomic) UILabel *textLabel;

/**
 Label to display the comment's details.
 */
@property(readonly, nonatomic) UILabel *detailTextLabel;

/**
 Label to display the comment's author avatar.
 */
@property(readonly, nonatomic) UIImageView *imageView;

/**
 Returns default font used for the `textLabel` property.
 
 @return A `UIFont` instance.
 */
+ (UIFont *)textFont;

/**
 Returns default font used for the and `detailTextLabel` properties.
 
 @return A `UIFont` instance.
 */
+ (UIFont *)detailTextFont;

/**
 Returns the optimal size for specfied text and width.
 
 @param text Text to calculate the size for.
 @param width Width to calculate the size for.
 @return Optimal size needed to display the cell.
 */
+ (CGSize)suggestedSizeForContent:(NSString *)content width:(CGFloat)width;

@end
