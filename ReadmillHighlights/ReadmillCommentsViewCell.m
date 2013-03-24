//
//  ReadmillCommentsViewCell.m
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 24/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import "ReadmillCommentsViewCell.h"

CGSize const ReadmillCommentsViewCellImageSize = { 48.0f, 48.0f };
UIEdgeInsets const ReadmillCommentsViewCellContentInset = { 8.0f, 8.0f, 8.0f, 6.0f };
CGFloat const ReadmillCommentsViewCellContentSpacing = 8.0f;

@interface ReadmillCommentsViewCell ()

/**
 Initialized the highlights cell.
 */
- (void)initializeReadmillCommentsViewCell;

@end

@implementation ReadmillCommentsViewCell
@synthesize textLabel = _rhTextLabel;
@synthesize detailTextLabel = _rhDetailTextLabel;
@synthesize imageView = _rhImageView;

#pragma mark -
#pragma mark Class Methods

+ (UIFont *)textFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
}

+ (UIFont *)detailTextFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0f];
}

+ (CGSize)suggestedSizeForContent:(NSString *)content width:(CGFloat)width
{
    UIFont *textFont = [self textFont];
    UIFont *dateFont = [self detailTextFont];
    
    CGFloat labelWidth = width-ReadmillCommentsViewCellContentInset.left-ReadmillCommentsViewCellImageSize.width-ReadmillCommentsViewCellContentSpacing-ReadmillCommentsViewCellContentInset.right;
    CGFloat minHeight = ReadmillCommentsViewCellContentInset.top+ReadmillCommentsViewCellImageSize.height+ReadmillCommentsViewCellContentInset.bottom;
    
    CGSize size = [content sizeWithFont:textFont constrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    size.width = width;
    size.height += ReadmillCommentsViewCellContentInset.top + ReadmillCommentsViewCellContentInset.bottom;
    size.height += dateFont.lineHeight;
    size.height = MAX(size.height, minHeight);
    
    return CGSizeMake(roundf(size.width), roundf(size.height));
}

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeReadmillCommentsViewCell];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeReadmillCommentsViewCell];
    }
    return self;
}

- (void)initializeReadmillCommentsViewCell
{
    _rhTextLabel = [UILabel new];
    _rhTextLabel.font = [[self class] textFont];
    _rhTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _rhTextLabel.highlightedTextColor = [UIColor whiteColor];
    [self.contentView addSubview:_rhTextLabel];
    
    _rhDetailTextLabel = [UILabel new];
    _rhDetailTextLabel.font = [[self class] detailTextFont];
    _rhDetailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _rhDetailTextLabel.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    _rhDetailTextLabel.highlightedTextColor = [UIColor whiteColor];
    [self.contentView addSubview:_rhDetailTextLabel];
    
    _rhImageView = [UIImageView new];
    _rhImageView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    [self.contentView addSubview:_rhImageView];
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGSize size = self.contentView.bounds.size;
    
    CGRect imageViewFrame = CGRectZero;
    imageViewFrame.origin.x = ReadmillCommentsViewCellContentInset.left;
    imageViewFrame.origin.y = ReadmillCommentsViewCellContentInset.top;
    imageViewFrame.size = ReadmillCommentsViewCellImageSize;
    self.imageView.frame = imageViewFrame;

    CGRect detailTextLabelFrame = CGRectZero;
    detailTextLabelFrame.origin.x = imageViewFrame.origin.x+imageViewFrame.size.width+ReadmillCommentsViewCellContentSpacing;
    detailTextLabelFrame.origin.y = ReadmillCommentsViewCellContentInset.top;
    detailTextLabelFrame.size = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font forWidth:(size.width-detailTextLabelFrame.origin.x-ReadmillCommentsViewCellContentInset.right) lineBreakMode:self.detailTextLabel.lineBreakMode];
    self.detailTextLabel.frame = detailTextLabelFrame;

    CGRect textLabelFrame = CGRectZero;
    textLabelFrame.origin.x = imageViewFrame.origin.x+imageViewFrame.size.width+ReadmillCommentsViewCellContentSpacing;
    textLabelFrame.origin.y = detailTextLabelFrame.origin.y+detailTextLabelFrame.size.height;
    textLabelFrame.size = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(size.width-textLabelFrame.origin.x-ReadmillCommentsViewCellContentInset.right, CGFLOAT_MAX) lineBreakMode:self.textLabel.lineBreakMode];
    self.textLabel.frame = textLabelFrame;
    self.textLabel.numberOfLines = ceilf(textLabelFrame.size.height/self.textLabel.font.lineHeight);
}

@end
