//
//  ReadmillHighlightViewController.m
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import "ReadmillHighlightViewController.h"
#import "ReadmillCommentsViewCell.h"
#import "UIAlertView+ReadmillHighlights.h"
#import "UIImageView+ReadmillHighlights.h"
#import "NSString+ReadmillHighlights.h"

UIEdgeInsets const ReadmillHighlightViewControllerHighlightContentInset = { 16.0f, 16.0f, 16.0f, 16.0f };

@interface ReadmillHighlightViewController ()

/**
 Comments retrieved from the Readmill API.
 */
@property(nonatomic) NSMutableArray *comments;

/**
 Text view for the highlight.
 */
@property(nonatomic) UITextView *textView;

/**
 Pull to refresh view.
 */
@property(nonatomic) SSPullToRefreshView *pullToRefresh;

/**
 Text label for the footer view.
 */
@property(nonatomic) UILabel *footerTextLabel;

/**
 Highlight view.
 */
@property(nonatomic) UIView *highlightView;

/**
 Table footer view.
 */
@property(nonatomic) UIView *footerView;

/**
 Returns the default font to be used for the `textView`.
 
 @return A `UIFont` instance.
 */
+ (UIFont *)textFont;

/**
 Returns the index for a comment at a given view index path.
 
 @param indexPath Index path to find comment index for.
 @return A `NSUInteger` value representing comment index in the `comments` array.
 */
- (NSUInteger)commentIndexForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ReadmillHighlightViewController

#pragma mark -
#pragma mark Class Methods

+ (UIFont *)textFont
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:19.0f];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSLocalizedString(@"Highlight", nil) uppercaseString];
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(0.0f, -1.0f, self.tableView.bounds.size.width, 1.0f);
    line.backgroundColor = self.tableView.separatorColor;
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.tableView addSubview:line];
    
    SSPullToRefreshSimpleContentView *contentView = [SSPullToRefreshSimpleContentView new];
    contentView.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    
    self.pullToRefresh = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    self.pullToRefresh.contentView = contentView;
    [self.pullToRefresh startLoadingAndExpand:YES animated:YES];

    self.tableView.tableHeaderView = self.highlightView;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.allowsSelection = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pullToRefresh = nil;
}

#pragma mark -
#pragma mark Properties

- (UIView *)highlightView
{
    if (!_highlightView) {
        self.textView = [UITextView new];
        self.textView.font = [[self class] textFont];
        self.textView.editable = NO;
        self.textView.text = self.highlight.content;
        
        CGRect frame = CGRectZero;
        frame.size = [self.textView sizeThatFits:CGSizeMake(self.view.bounds.size.width-ReadmillHighlightViewControllerHighlightContentInset.left-ReadmillHighlightViewControllerHighlightContentInset.right, CGFLOAT_MAX)];
        frame.origin.x = ReadmillHighlightViewControllerHighlightContentInset.left;
        frame.origin.y = ReadmillHighlightViewControllerHighlightContentInset.top;
        self.textView.frame = frame;
        
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = frame.size.height+ReadmillHighlightViewControllerHighlightContentInset.top+ReadmillHighlightViewControllerHighlightContentInset.bottom;
        
        UIView *line = [UIView new];
        line.frame = CGRectMake(0.0f, height-1.0f, width, 1.0f);
        line.backgroundColor = self.tableView.separatorColor;
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        _highlightView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        [_highlightView addSubview:self.textView];
        [_highlightView addSubview:line];

    }
    return _highlightView;
}

- (UILabel *)footerTextLabel
{
    if (!_footerTextLabel) {
        _footerTextLabel = [UILabel new];
        _footerTextLabel.font = [[self class] textFont];
        _footerTextLabel.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
        _footerTextLabel.text = NSLocalizedString(@"No Comments", nil);
        [_footerTextLabel sizeToFit];
    }
    return _footerTextLabel;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [UIView new];
        [_footerView addSubview:self.footerTextLabel];
    }
    
    CGRect frame = CGRectZero;
    frame.size.width = self.tableView.bounds.size.width;
    frame.size.height = roundf([[[self class] textFont] lineHeight]*3.0f);
    _footerView.frame = frame;
    
    self.footerTextLabel.center = _footerView.center;

    return _footerView;
}

#pragma mark -
#pragma mark Instance Methods

- (void)loadComments:(id)sender
{
    if (!self.comments) {
        self.comments = [NSMutableArray array];
    }
    [self.highlight updateWithDelegate:self];
    [self.highlight findCommentsWithCount:100 fromDate:nil toDate:nil delegate:self];
}

- (NSUInteger)commentIndexForIndexPath:(NSIndexPath *)indexPath
{
    return self.highlight.likesCount > 0 ? indexPath.row-1 : indexPath.row;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.highlight.likesCount ? [self.comments count]+1 : [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LikesCellIdentifier = @"LikesCell";
    static NSString *CommentCellIdentifier = @"CommentCell";
    
    // Likes count cell.
    if (self.highlight.likesCount > 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LikesCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LikesCellIdentifier];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
            cell.textLabel.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
        }
        cell.textLabel.text = [NSString stringWithEmptyFormat:NSLocalizedString(@"No likes", nil) singularFormat:NSLocalizedString(@"%d like", nil) pluralFormat:NSLocalizedString(@"%d likes", nil) count:self.highlight.likesCount];
        return cell;
    }
    // Comment cell.
    else {
        ReadmillCommentsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
        if (!cell) {
            cell = [[ReadmillCommentsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentCellIdentifier];
        }
        
        static NSDateFormatter *DateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            DateFormatter = [[NSDateFormatter alloc] init];
            DateFormatter.locale = [NSLocale currentLocale];
            DateFormatter.dateStyle = NSDateFormatterShortStyle;
            DateFormatter.timeStyle = NSDateFormatterShortStyle;
            DateFormatter.doesRelativeDateFormatting = YES;
        });
        
        ReadmillComment *comment = [self.comments objectAtIndex:[self commentIndexForIndexPath:indexPath]];
        cell.textLabel.text = comment.content;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ・ %@", comment.user.fullName, [DateFormatter stringFromDate:comment.postedAt]];
        [cell.imageView setImageWithURL:[comment.user avatarURLWithSize:ReadmillUserAvatarSizeMediumLarge] completionHandler:nil];
        
        return cell;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.highlight.likesCount > 0 && indexPath.row == 0) {
        return 40.0f;
    }
    
    ReadmillComment *comment = [self.comments objectAtIndex:[self commentIndexForIndexPath:indexPath]];
    CGSize size = [ReadmillCommentsViewCell suggestedSizeForContent:comment.content width:tableView.bounds.size.width];
    return size.height;
}

#pragma mark -
#pragma mark ReadmillCommentsFindingDelegate

- (void)readmillHighlight:(ReadmillHighlight *)highlight didFindComments:(NSArray *)comments fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    [self.pullToRefresh finishLoading];
    self.tableView.tableFooterView = comments.count == 0 ? self.footerView : nil;
    
    [self.comments removeAllObjects];
    [self.comments addObjectsFromArray:comments];
    [self.tableView reloadData];
}

- (void)readmillHighlight:(ReadmillHighlight *)highlight failedToFindCommentsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withError:(NSError *)error
{
    [self.pullToRefresh finishLoading];
    [UIAlertView showError:error withTitle:NSLocalizedString(@"Error Finding Comments", nil) cancelButtonTitle:NSLocalizedString(@"OK", nil)];
}

#pragma mark -
#pragma mark ReadmillHighlightUpdateDelegate

- (void)readmillHighlightUpdateDidSucceedWithHighlight:(ReadmillHighlight *)highlight
{
    self.textView.text = highlight.content;
    self.tableView.tableHeaderView = self.highlightView;
    [self.tableView reloadData];
}

- (void)readmillHighlightUpdateDidFailWithHighlight:(ReadmillHighlight *)highlight error:(NSError *)error
{
    [UIAlertView showError:error withTitle:NSLocalizedString(@"Error Finding Comments", nil) cancelButtonTitle:NSLocalizedString(@"OK", nil)];
}

#pragma mark -
#pragma mark SSPullToRefreshViewDelegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self loadComments:view];
}

@end
