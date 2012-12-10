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
#import <QuartzCore/QuartzCore.h>

static NSString * kShowComposersSegueIdentifier = @"ShowComposers";

@interface MUSDecadeScoreCollectionViewController ()

@property (nonatomic, strong) IBOutlet UIView *toolbarContainerView;
@property (nonatomic, strong) UIPopoverController *composersPopover;
@property (nonatomic) NSInteger composersSegmentIndex;
@property (nonatomic, strong) NSIndexPath *composersIndexPath;
@property (nonatomic, strong) NSString *composer;

- (void)saveSelections:(UIPopoverController *)popoverController;

@end

@implementation MUSDecadeScoreCollectionViewController

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
    [self addObserver:self forKeyPath:@"decade" options:NSKeyValueObservingOptionNew context:NULL];
    [self.indexView setDelegate:self];
    
    [self.toolbarContainerView.layer setCornerRadius:5.0f];
    [self.toolbarContainerView.layer setMasksToBounds:YES];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.decade == nil) {
        [self.composersButtonItem setEnabled:NO];
        [self.indexView setHidden:YES];
    } else {
        [self.composersButtonItem setEnabled:YES];
        [self.indexView setHidden:NO];
    }
}

- (NSString *)titleString
{
    if (self.composer!=nil) {
        return [NSString stringWithFormat:@"%@ (%i items)", self.composer, [self numberOfScoresInCollection]];
    } else if (self.decade!=nil) {
        NSString *endOfDecade = [NSString stringWithFormat:@"%i", [self.decade intValue] + 9];
        int count = [self.dataController numberOfScoresInDecade:self.decade];
        NSString *title = [NSString stringWithFormat:@"%@ - %@ (%i items)", self.decade, endOfDecade, count];
        return title;
    } else {
        return @"";
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
    
    if ([self isOpenScoreSegue:segue]) {
        MUSScoreViewController *scoreController = (MUSScoreViewController *)segue.destinationViewController;
        [scoreController setDelegate:nil];
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

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"decade"];
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
    [self.titleLabel setText:self.titleString];
    [self.collectionView reloadData];
    
    // show the a - z index
    [self.indexView setHidden:NO];
}

- (void)composersTableViewController:(MUSComposersTableViewController *)controller didSelectComposerWithInfo:(NSDictionary *)composerInfo
{
    [self setComposer:composerInfo[@"creator"]];
    [self.titleLabel setText:self.titleString];
    [self.collectionView reloadData];
    
    // it doesn't make sense to have an A - Z index for a single composer, so hide it
    [self.indexView setHidden:YES];
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


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"decade"]) {
        [self setComposer:nil];
        [self setComposersIndexPath:nil];
        [self setComposersSegmentIndex:0];

        [self.titleLabel setText:self.titleString];
        [self.composersButtonItem setEnabled:YES];
        [self.collectionView reloadData];
        NSIndexPath *firstItemPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:firstItemPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        [self.indexView setHidden:NO];
    }
}

#pragma mark - A to Z Index View Delegate Methods

- (void)indexViewDidSelectLetterInIndex:(NSString *)letter
{
    // scroll the collection view to the right place
    NSIndexPath *indexPathOfFirstScoreWithLetter = [self.dataController indexOfFirstScoreWithLetter:letter inDecade:self.decade];
    [self.collectionView scrollToItemAtIndexPath:indexPathOfFirstScoreWithLetter
                                atScrollPosition:UICollectionViewScrollPositionTop
                                        animated:NO];
}

@end
