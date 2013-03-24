//
//  ReadmillHighlightsViewController.m
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import "ReadmillHighlightsViewController.h"
#import "ReadmillHighlightViewController.h"
#import "ReadmillHighlightsViewCell.h"
#import "ReadmillUser+ReadmillHighlights.h"
#import "UIAlertView+ReadmillHighlights.h"
#import "NSString+ReadmillHighlights.h"

@interface ReadmillHighlightsViewController ()

/**
 Highlights, retrieved from the Internet.
 */
@property(nonatomic) NSMutableArray *highlights;

/**
 Pull to refresh view.
 */
@property(nonatomic) SSPullToRefreshView *pullToRefresh;

@end

@implementation ReadmillHighlightsViewController
@synthesize highlights = _highlights;

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSLocalizedString(@"Your Highlights", nil) uppercaseString];
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.rowHeight = 111.0f;
    
    SSPullToRefreshSimpleContentView *contentView = [SSPullToRefreshSimpleContentView new];
    contentView.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    
    self.pullToRefresh = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    self.pullToRefresh.contentView = contentView;
    [self.pullToRefresh startLoadingAndExpand:YES animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pullToRefresh = nil;
}

#pragma mark -
#pragma mark Instance Methods

- (void)loadHighlights:(id)sender
{
    if (!self.highlights) {
        self.highlights = [NSMutableArray array];
    }
    [[ReadmillUser currentUser] findHighlightsWithCount:100 fromDate:nil toDate:nil delegate:self];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.highlights count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ReadmillHighlightsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ReadmillHighlightsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    static NSDateFormatter *DateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DateFormatter = [[NSDateFormatter alloc] init];
        DateFormatter.locale = [NSLocale currentLocale];
        DateFormatter.dateStyle = NSDateFormatterMediumStyle;
        DateFormatter.timeStyle = NSDateFormatterNoStyle;
        DateFormatter.doesRelativeDateFormatting = YES;
    });
    
    ReadmillHighlight *highlight = [self.highlights objectAtIndex:indexPath.row];
    
    cell.textLabel.text = highlight.content;
    
    NSMutableString *detailText = [[NSMutableString alloc] initWithString:[DateFormatter stringFromDate:highlight.highlightedAt]];
    if (highlight.likesCount) {
        [detailText appendString:[NSString stringWithEmptyFormat:NSLocalizedString(@"No likes", nil) singularFormat:NSLocalizedString(@" ・ %d like", nil) pluralFormat:NSLocalizedString(@" ・ %d likes", nil) count:highlight.likesCount]];
    }
    if (highlight.commentsCount) {
        [detailText appendString:[NSString stringWithEmptyFormat:NSLocalizedString(@"No comments", nil) singularFormat:NSLocalizedString(@" ・ %d comment", nil) pluralFormat:NSLocalizedString(@" ・ %d comments", nil) count:highlight.commentsCount]];
    }
    
    cell.detailTextLabel.text = [detailText uppercaseString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadmillHighlight *highlight = [self.highlights objectAtIndex:indexPath.row];
    CGSize size = [ReadmillHighlightsViewCell suggestedSizeForText:highlight.content width:tableView.bounds.size.width];
    return size.height;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadmillHighlightViewController *controller = [ReadmillHighlightViewController new];
    controller.highlight = [self.highlights objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ReadmillHighlight *highlight = [self.highlights objectAtIndex:indexPath.row];
        [highlight.apiWrapper deleteHighlightWithId:highlight.highlightId completionHandler:^(id result, NSError *error) {
            if (!error) {
                [self.highlights removeObject:highlight];
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
            }
        }];
    }
}*/

#pragma mark -
#pragma mark ReadmillHighlightsFindingDelegate

- (void)readmillUser:(ReadmillUser *)user didFindHighlights:(NSArray *)highlights fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    [self.pullToRefresh finishLoading];
    [self.highlights removeAllObjects];
    [self.highlights addObjectsFromArray:highlights];
    [self.highlights sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"highlightedAt" ascending:NO]]];
    [self.tableView reloadData];
}

- (void)readmillUser:(ReadmillUser *)user failedToFindHighlightsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withError:(NSError *)error
{
    [self.pullToRefresh finishLoading];
    [UIAlertView showError:error withTitle:NSLocalizedString(@"Error Finding Highlights", nil) cancelButtonTitle:NSLocalizedString(@"OK", nil)];
}

#pragma mark -
#pragma mark SSPullToRefreshViewDelegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
    [self loadHighlights:view];
}

@end
