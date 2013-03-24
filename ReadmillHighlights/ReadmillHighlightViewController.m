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

UIEdgeInsets const ReadmillHighlightViewControllerHighlightContentInset = { 16.0f, 16.0f, 16.0f, 16.0f };

@interface ReadmillHighlightViewController ()

@property(nonatomic) NSMutableArray *comments;
@property(nonatomic) UITextView *textView;

@end

@implementation ReadmillHighlightViewController

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadComments:)];
    
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
    
    UIView *highlightView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    [highlightView addSubview:self.textView];
    [highlightView addSubview:line];
    
    self.tableView.tableHeaderView = highlightView;
    self.tableView.allowsSelection = NO;
}

- (void)setHighlight:(ReadmillHighlight *)highlight
{
    _highlight = highlight;
    [self loadComments:self];
}

- (void)loadComments:(id)sender
{
    if (!self.comments) {
        self.comments = [NSMutableArray array];
    } else {
        [self.comments removeAllObjects];
    }
    [self.highlight findCommentsWithCount:100 fromDate:nil toDate:nil delegate:self];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCell";
    ReadmillCommentsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ReadmillCommentsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    
    ReadmillComment *comment = [self.comments objectAtIndex:indexPath.row];
    cell.textLabel.text = comment.content;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ・ %@", comment.user.fullName, [DateFormatter stringFromDate:comment.postedAt]];
    [cell.imageView setImageWithURL:[comment.user avatarURLWithSize:ReadmillUserAvatarSizeMediumLarge] completionHandler:nil];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadmillComment *comment = [self.comments objectAtIndex:indexPath.row];
    CGSize size = [ReadmillCommentsViewCell suggestedSizeForContent:comment.content width:tableView.bounds.size.width];
    return size.height;
}

#pragma mark -
#pragma mark ReadmillCommentsFindingDelegate

- (void)readmillHighlight:(ReadmillHighlight *)highlight didFindComments:(NSArray *)comments fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    [self.comments addObjectsFromArray:comments];
    [self.tableView reloadData];
}

- (void)readmillHighlight:(ReadmillHighlight *)highlight failedToFindCommentsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withError:(NSError *)error
{
    [UIAlertView showError:error withTitle:NSLocalizedString(@"Error Finding Comments", nil) cancelButtonTitle:NSLocalizedString(@"OK", nil)];
}

@end
