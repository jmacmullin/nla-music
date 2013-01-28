//
//  MUSFavouriteScoreCollectionViewController.m
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

#import "MUSFavouriteScoreCollectionViewController.h"

@implementation MUSFavouriteScoreCollectionViewController

#pragma mark - Overridden Methods

- (NSString *)titleString
{
    return @"Favourites";
}

- (NSString *)trackedViewName
{
    return @"Favourites";
}

- (int)numberOfScoresInCollection
{
    return [self.dataController numberOfFavouriteScores];
}

- (Score *)scoreAtIndexPathInCollection:(NSIndexPath *)indexPath
{
    return [self.dataController scoreAtIndexInFavourites:indexPath.row];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([self isOpenScoreSegue:segue] == YES) {
        MUSScoreViewController *scoreController = (MUSScoreViewController *)segue.destinationViewController;
        [scoreController setDelegate:self];
        
        NSString *lastOpenedPageNumberKey = [NSString stringWithFormat:@"%@-last-opened-page", self.selectedScore.identifier];
        int lastOpenedPageNumber = [[NSUserDefaults standardUserDefaults] integerForKey:lastOpenedPageNumberKey];
        [scoreController setInitialPageNumber:lastOpenedPageNumber];
    }
    
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - Score View Controller Delegate Methods

- (void)scoreViewController:(MUSScoreViewController *)controller didDismissScore:(Score *)score atPageNumber:(int)pageNumber
{
    NSString *lastOpenedPageNumberKey = [NSString stringWithFormat:@"%@-last-opened-page", score.identifier];
    [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:lastOpenedPageNumberKey];
}

@end
