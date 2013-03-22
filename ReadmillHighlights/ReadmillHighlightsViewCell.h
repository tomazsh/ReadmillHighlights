//
//  ReadmillHighlightsViewCell.h
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Content inset for the cell.
 */
extern UIEdgeInsets const ReadmillHighlightsViewCellContentInset;

/**
 The ReadmillHighlightsViewCell is used to display a single highlight in the list.
 */
@interface ReadmillHighlightsViewCell : UITableViewCell

/**
 Text label to display the content of the highlight.
 */
@property(readonly, nonatomic) UILabel *textLabel;

/**
 Label to display the highlight details.
 */
@property(readonly, nonatomic) UILabel *detailTextLabel;

/**
 Returns default font used for the `textLabel` property.
 
 @return A `UIFont` instance.
 */
+ (UIFont *)textFont;

/**
 Returns default font used for the `detailTextLabel` property.
 
 @return A `UIFont` instance.
 */
+ (UIFont *)detailTextFont;

/**
 Returns the optimal size for specfied text and width.
 
 @param text Text to calculate the size for.
 @param width Width to calculate the size for.
 @return Optimal size needed to display the cell.
 */
+ (CGSize)suggestedSizeForText:(NSString *)text width:(CGFloat)width;

@end
