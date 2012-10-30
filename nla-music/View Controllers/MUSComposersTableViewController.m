//
//  MUSComposersTableViewController.m
//  nla-music
//
//  Copyright © 2012 Jake MacMullin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "MUSComposersTableViewController.h"
#import "MUSComposerCell.h"

@interface MUSComposersTableViewController ()

@property NSArray *composers;
@property NSArray *composersByName;
@property NSArray *composersByCount;
@property int maximumNumberByOneComposer;

@end

@implementation MUSComposersTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self!=nil) {
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationItem setTitleView:self.orderSwitcher];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setComposersByName:[self.dataController composersWithMusicPublishedIn:self.decade]];
    [self setComposersByCount:[self.composersByName
                               sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                   NSDictionary *composerInformation1 = (NSDictionary *)obj1;
                                   NSDictionary *composerInformation2 = (NSDictionary *)obj2;
                                   
                                   int count1 = [[composerInformation1 valueForKey:@"count"] intValue];
                                   int count2 = [[composerInformation2 valueForKey:@"count"] intValue];
                                   
                                   if (count1 > count2) {
                                       return NSOrderedAscending;
                                   } else if (count1 == count2 ) {
                                       return NSOrderedSame;
                                   } else {
                                       return NSOrderedDescending;
                                   }
    }]];
    [self setMaximumNumberByOneComposer:[[self.composersByCount[0] valueForKey:@"count"] intValue]];
    [self setComposers:self.composersByName];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.composers.count < 17.0) {
        [self setContentSizeForViewInPopover:CGSizeMake(360.0, (self.composers.count * 44.0) + 44.0)];
    }   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.composers.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"AllCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        return cell;
    } else {
        static NSString *CellIdentifier = @"ComposerCell";
        MUSComposerCell *cell = (MUSComposerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSDictionary *composerInformation = self.composers[indexPath.row];
        [cell setMaximumNumberOfScores:self.maximumNumberByOneComposer];
        [cell setComposerInfo:composerInformation];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UI Actions

- (IBAction)switchSortOrder:(id)sender
{
    NSMutableArray *rowsToMove = [NSMutableArray array];
    
    NSArray *fromOrder;
    NSArray *toOrder;
    
    if (self.composers == self.composersByName) {
        fromOrder = self.composersByName;
        toOrder = self.composersByCount;
    } else {
        fromOrder = self.composersByCount;
        toOrder = self.composersByName;
    }
        
    // get the index paths for the currently visible rows
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    
    int firstVisibleComposer = -1;
    int lastVisibleComposer = -1;
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        if (indexPath.section == 1) {
            if (firstVisibleComposer == -1) {
                firstVisibleComposer = indexPath.row;
            } else {
                lastVisibleComposer = indexPath.row;
            }
        }
    }
    
    // get the composers for the visible rows
    NSArray *visibleComposers = [fromOrder subarrayWithRange:NSMakeRange(firstVisibleComposer, lastVisibleComposer - firstVisibleComposer)];
    
    int i = 0;
    for (NSDictionary *composerInfo in visibleComposers) {
        // current index
        NSIndexPath *currentIndex = [NSIndexPath indexPathForRow:firstVisibleComposer + i inSection:1];
        
        // new index
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:[toOrder indexOfObject:composerInfo] inSection:1];
        
        if (newIndex!=currentIndex) {
            NSDictionary *indexChangeDict = @{
            @"from": currentIndex,
            @"to": newIndex
            };
            [rowsToMove addObject:indexChangeDict];
        }
        
        i++;
    }
    
    // get the composers who will become visible
    NSArray *composersThatWillBecomeVisible = [toOrder subarrayWithRange:NSMakeRange(firstVisibleComposer, lastVisibleComposer - firstVisibleComposer)];
    i = 0;
    for (NSDictionary *composerInfo in composersThatWillBecomeVisible) {
        // current index
        NSIndexPath *currentIndex = [NSIndexPath indexPathForRow:[fromOrder indexOfObject:composerInfo] inSection:1];
        
        // new index
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:firstVisibleComposer + i inSection:1];
        
        if (newIndex!=currentIndex) {
            NSDictionary *indexChangeDict = @{
            @"from": currentIndex,
            @"to": newIndex
            };
            [rowsToMove addObject:indexChangeDict];
        }
        
        i++;
    }
    
    [self setComposers:toOrder];
    
    
    // now actually move the rows
    [self.tableView beginUpdates];
    for (NSDictionary *indexChangeDict in rowsToMove) {
        [self.tableView moveRowAtIndexPath:indexChangeDict[@"from"] toIndexPath:indexChangeDict[@"to"]];
    }
    [self.tableView endUpdates];
}

@end
