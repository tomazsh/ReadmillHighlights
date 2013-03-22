//
//  ReadmillHighlightsViewController.m
//  ReadmillHighlights
//
//  Created by Tomaz Nedeljko on 22/3/13.
//  Copyright (c) 2013 Readmill. All rights reserved.
//

#import "ReadmillHighlightsViewController.h"
#import "ReadmillHighlightsViewCell.h"
#import "ReadmillUser+ReadmillHighlights.h"
#import "UIAlertView+ReadmillHighlights.h"

/**
 This is really not production code, but it works for a demonstration purposes.
 */
NSString * ReadmillHighlightsPluralizedString(NSString *singularFormat, NSString *pluralFormat, NSUInteger count) {
    if (count < 2) {
        return [NSString stringWithFormat:singularFormat, count];
    } else {
        return [NSString stringWithFormat:pluralFormat, count];
    }
}

@interface ReadmillHighlightsViewController ()

/**
 Highlights, retrieved from the Internet.
 */
@property(nonatomic) NSMutableArray *highlights;

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadHighlights:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark -
#pragma mark Instance Methods

- (void)loadHighlights:(id)sender
{
    if (!self.highlights) {
        self.highlights = [NSMutableArray array];
    } else {
        [self.highlights removeAllObjects];
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
        [detailText appendString:ReadmillHighlightsPluralizedString(@" ・ %d like", @" ・ %d likes", highlight.likesCount)];
    }
    if (highlight.commentsCount) {
        [detailText appendString:ReadmillHighlightsPluralizedString(@" ・ %d comment", @" ・ %d comments", highlight.commentsCount)];
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
    self.navigationItem.rightBarButtonItem.enabled = YES;

    [self.highlights addObjectsFromArray:highlights];
    [self.highlights sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"highlightedAt" ascending:NO]]];
    [self.tableView reloadData];
}

- (void)readmillUser:(ReadmillUser *)user failedToFindHighlightsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withError:(NSError *)error
{
    self.navigationItem.rightBarButtonItem.enabled = YES;

    [UIAlertView showError:error withTitle:NSLocalizedString(@"Error Finding Highlights", nil) cancelButtonTitle:NSLocalizedString(@"OK", nil)];
}

@end
