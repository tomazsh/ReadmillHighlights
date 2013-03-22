//
//  ReadmillHighlightsViewCell.m
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import "ReadmillHighlightsViewCell.h"

UIEdgeInsets const ReadmillHighlightsViewCellContentInset = { 8.0f, 8.0f, 8.0f, 6.0f };

@interface ReadmillHighlightsViewCell ()

/**
 Initialized the highlights cell.
 */
- (void)initializeReadmillHighlightsViewCell;

@end

@implementation ReadmillHighlightsViewCell
@synthesize textLabel = _rhTextLabel;
@synthesize detailTextLabel = _rhDetailTextLabel;

#pragma mark -
#pragma mark Class Methods

+ (UIFont *)textFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
}

+ (UIFont *)detailTextFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
}

+ (CGSize)suggestedSizeForText:(NSString *)text width:(CGFloat)width
{
    UIFont *textFont = [self textFont];
    UIFont *dateFont = [self detailTextFont];
    
    CGSize size = [text sizeWithFont:textFont constrainedToSize:CGSizeMake(width, textFont.lineHeight*3.0f) lineBreakMode:(NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail)];
    size.height += ReadmillHighlightsViewCellContentInset.top + ReadmillHighlightsViewCellContentInset.bottom + dateFont.lineHeight + dateFont.lineHeight/2.0f;
    return CGSizeMake(roundf(size.width), roundf(size.height));
}

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeReadmillHighlightsViewCell];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeReadmillHighlightsViewCell];
    }
    return self;
}

- (void)initializeReadmillHighlightsViewCell
{
    _rhTextLabel = [UILabel new];
    _rhTextLabel.font = [[self class] textFont];
    _rhTextLabel.numberOfLines = 3;
    _rhTextLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    _rhTextLabel.highlightedTextColor = [UIColor whiteColor];
    [self.contentView addSubview:_rhTextLabel];
    
    _rhDetailTextLabel = [UILabel new];
    _rhDetailTextLabel.font = [[self class] detailTextFont];
    _rhDetailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _rhDetailTextLabel.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    _rhDetailTextLabel.highlightedTextColor = [UIColor whiteColor];
    [self.contentView addSubview:_rhDetailTextLabel];
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect textLabelFrame = self.contentView.frame;
    textLabelFrame.origin.x = ReadmillHighlightsViewCellContentInset.left;
    textLabelFrame.origin.y = ReadmillHighlightsViewCellContentInset.top;
    textLabelFrame.size.width -= ReadmillHighlightsViewCellContentInset.left+ReadmillHighlightsViewCellContentInset.right;
    textLabelFrame.size.height -= ReadmillHighlightsViewCellContentInset.top+ReadmillHighlightsViewCellContentInset.bottom+self.detailTextLabel.font.lineHeight+self.detailTextLabel.font.lineHeight/2.0f;
    self.textLabel.frame = textLabelFrame;
    
    CGRect dateLabelFrame = textLabelFrame;
    dateLabelFrame.size = [self.detailTextLabel sizeThatFits:CGSizeMake(textLabelFrame.size.width, CGFLOAT_MAX)];
    dateLabelFrame.origin.x = ReadmillHighlightsViewCellContentInset.left;
    dateLabelFrame.origin.y = textLabelFrame.origin.y+textLabelFrame.size.height+self.detailTextLabel.font.lineHeight/2.0f;
    self.detailTextLabel.frame = dateLabelFrame;
}

@end
