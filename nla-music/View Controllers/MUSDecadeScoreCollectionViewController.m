//
//  MUSDecadeScoreCollectionViewController.m
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

#import "MUSDecadeScoreCollectionViewController.h"
#import "MUSScoreCell.h"
#import "NINetworkImageView.h"
#import "MUSScoreViewController.h"
#import "MUSTimelineViewController.h"

static NSString * kShowComposersSegueIdentifier = @"ShowComposers";

@interface MUSDecadeScoreCollectionViewController ()

@property (nonatomic, strong) UIPopoverController *composersPopover;
@property (nonatomic) NSInteger composersSegmentIndex;
@property (nonatomic, strong) NSIndexPath *composersIndexPath;
@property (nonatomic, strong) NSString *composer;

- (void)saveSelections:(UIPopoverController *)popoverController;

@end

@implementation MUSDecadeScoreCollectionViewController

#pragma mark - Overridden Methods

- (NSString *)titleString
{
    if (self.composer!=nil) {
        return [NSString stringWithFormat:@"%@ (%i items)", self.composer, [self numberOfScoresInCollection]];
    } else {
        NSString *endOfDecade = [NSString stringWithFormat:@"%i", [self.decade intValue] + 9];
        int count = [self.dataController numberOfScoresInDecade:self.decade];
        NSString *title = [NSString stringWithFormat:@"%@ - %@ (%i items)", self.decade, endOfDecade, count];
        return title;
    }
}

- (int)numberOfScoresInCollection
{
    if (self.composer == nil) {
        return [self.dataController numberOfScoresInDecade:self.decade];
    } else {
        return [self.dataController numberOfScoresInDecade:self.decade byComposer:self.composer];
    }
}

- (Score *)scoreAtIndexPathInCollection:(NSIndexPath *)indexPath
{
    if (self.composer == nil) {
        return [self.dataController scoreAtIndex:indexPath inDecade:self.decade];
    } else {
        return [self.dataController scoreAtIndex:indexPath inDecade:self.decade byComposer:self.composer];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:kShowComposersSegueIdentifier] && self.composersPopover.isPopoverVisible == YES) {
        // Don't show the composers popover if it is already visible,
        // but dismiss it instead
        [self saveSelections:self.composersPopover];
        [self.composersPopover dismissPopoverAnimated:YES];
        return NO;
    }
    
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:kShowComposersSegueIdentifier]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        MUSComposersTableViewController *composersTableViewController = (MUSComposersTableViewController *)navigationController.viewControllers[0];
        [composersTableViewController setDecade:self.decade];
        [composersTableViewController setDataController:self.dataController];
        [composersTableViewController setDelegate:self];
        UIPopoverController *popoverController = ((UIStoryboardPopoverSegue *)segue).popoverController;
        [self setComposersPopover:popoverController];
        [popoverController setDelegate:self];
        
        // restore the previous selections
        [composersTableViewController setSelectedSegmentIndex:self.composersSegmentIndex];
        [composersTableViewController setSelectedIndexPath:self.composersIndexPath];
    }

}

- (void)dismiss:(id)sender
{
    // dismiss the popover if it is visible
    if (self.composersPopover!=nil) {
        [self saveSelections:self.composersPopover];
        [self.composersPopover dismissPopoverAnimated:YES];
    }
    [self setComposersPopover:nil];
    
    [super dismiss:sender];
}


#pragma mark - Popover Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self saveSelections:popoverController];
}


#pragma mark - Composers Table View Controller Delegate Methods

- (void)composersTableViewControllerDidSelectAllComposers:(MUSComposersTableViewController *)controller
{
    [self setComposer:nil];
    [self.titleItem setTitle:[self titleString]];
    [self.collectionView reloadData];
}

- (void)composersTableViewController:(MUSComposersTableViewController *)controller didSelectComposerWithInfo:(NSDictionary *)composerInfo
{
    [self setComposer:composerInfo[@"creator"]];
    [self.titleItem setTitle:[self titleString]];
    [self.collectionView reloadData];
}


#pragma mark - Private Methods

- (void)saveSelections:(UIPopoverController *)popoverController
{
    // remember the selections (so we can restore them)
    UINavigationController *navigationController = (UINavigationController *)popoverController.contentViewController;
    MUSComposersTableViewController *composersTableViewController = (MUSComposersTableViewController *)navigationController.topViewController;
    [self setComposersIndexPath:composersTableViewController.selectedIndexPath];
    [self setComposersSegmentIndex:composersTableViewController.selectedSegmentIndex];
}

@end
