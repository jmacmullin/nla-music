//
//  MUSIndexViewController.m
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

#import "MUSIndexViewController.h"
#import "MUSScoreCell.h"
#import "NINetworkImageView.h"
#import "MUSScoreViewController.h"

@interface MUSIndexViewController ()

@property (nonatomic, strong) NSIndexPath *selectedScoreIndex;
@property (nonatomic, strong) Score *selectedScore;
@property (nonatomic, strong) NINetworkImageView *selectedCoverImageView;

@end

@implementation MUSIndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self!=nil) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDataController:[MUSDataController sharedController]];
}

- (void)viewDidAppear:(BOOL)animated
{
    // If there's a selectedScore and selectedCoverImageView
    // then scale the image down again
    if (self.selectedScore!=nil && self.selectedCoverImageView!=nil) {
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.selectedScoreIndex];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        CGPoint convertedPoint = [self.collectionView convertPoint:cell.frame.origin toView:window];
        // allow for the space that the thumbnail is inset from the cell
        convertedPoint = CGPointMake(convertedPoint.x + 51.0, convertedPoint.y); //TODO: lose these magic numbers!
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.selectedCoverImageView setFrame:CGRectMake(convertedPoint.x, convertedPoint.y, 121.0, 150.0)];
                         }
                         completion:^(BOOL finished) {
                             [self.selectedCoverImageView removeFromSuperview];
                             [self setSelectedCoverImageView:nil];
                             [self setSelectedScore:nil];
                             [self setSelectedScoreIndex:nil];
                         }
         ];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView Data Source Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataController numberOfScores];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MUSScoreCell *cell = (MUSScoreCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ScoreCell" forIndexPath:indexPath];
    Score *score = [self.dataController scoreAtIndex:indexPath];
    [cell setScore:score];
    return cell;
}

#pragma mark - UICollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // take note of the selected score
    [self setSelectedScore:[self.dataController scoreAtIndex:indexPath]];
    [self setSelectedScoreIndex:indexPath];
    
    // get the selected cell
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    // convert the origin of the selected cell to window coordinates
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGPoint convertedPoint = [collectionView convertPoint:cell.frame.origin toView:window];
    
    // allow for the space that the thumbnail is inset from the cell
    convertedPoint = CGPointMake(convertedPoint.x + 51.0, convertedPoint.y); //TODO: lose these magic numbers!
    
    // create a new image view to scale to fill the view
    NINetworkImageView *coverImageView = [[NINetworkImageView alloc] initWithFrame:CGRectMake(convertedPoint.x, convertedPoint.y, 121.0, 150.0)];
    [coverImageView setPathToNetworkImage:[self.selectedScore.thumbnailURL absoluteString]];
    [self.view addSubview:coverImageView];
    [self setSelectedCoverImageView:coverImageView];
    
    // animate the image to fill the view
    [UIView animateWithDuration:0.25
                     animations:^{
                         [coverImageView setFrame:self.view.bounds];
                     }
                     completion:^(BOOL finished) {
                         [coverImageView setPathToNetworkImage:[self.selectedScore.coverURL absoluteString]];
                         [self performSegueWithIdentifier:@"openScoreSegue" sender:self];
                     }];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openScoreSegue"]) {
        MUSScoreViewController *scoreController = (MUSScoreViewController *)segue.destinationViewController;
        [scoreController setScore:self.selectedScore];
        [scoreController setInitialImage:self.selectedCoverImageView.image];
    }
}

@end
