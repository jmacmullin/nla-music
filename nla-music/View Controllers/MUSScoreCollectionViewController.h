//
//  MUSScoreCollectionViewController.h
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

#import <Foundation/Foundation.h>
#import "MUSDataController.h"
#import "NINetworkImageView.h"

/**
 A view controller that manages a collection of scores.
 This is the common superclass for both the MUSFavouriteScoreCollectionViewController
 (which manages a collection of favourite scores) and the
 MUSDecadeScoreCollectionViewController (which manages a collection of scores published
 in a given decade).
 */
@interface MUSScoreCollectionViewController : UIViewController

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *titleItem;
@property (nonatomic, strong) MUSDataController *dataController;
@property (nonatomic, strong) NSIndexPath *selectedScoreIndex;
@property (nonatomic, strong) Score *selectedScore;
@property (nonatomic, strong) NINetworkImageView *selectedCoverImageView;

/**
 The title that should be displayed in the toolbar. The default
 implementation returns an empty string. Subclasses should override
 this method to display a specific title.
 */
@property (nonatomic, readonly) NSString *titleString;


/**
 The number of scores in the collection. The default implementation
 returns 0. Subclasses should override this method to return a positive
 integer.
 */
@property (nonatomic, readonly) int numberOfScoresInCollection;


/**
 The Score at the given index path in the collection. The default
 implementation returns nil. Subclasses should override this method
 to return an actual score.
 */
- (Score *)scoreAtIndexPathInCollection:(NSIndexPath *)indexPath;


/**
 Determines if the given segue is opening a score.
 */
- (BOOL)isOpenScoreSegue:(UIStoryboardSegue *)segue;


/**
 Dismiss the index view.
 */
- (IBAction)dismiss:(id)sender;


@end
