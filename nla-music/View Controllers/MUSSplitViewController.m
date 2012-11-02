//
//  MUSSplitViewController.m
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

#import "MUSSplitViewController.h"
#import "MUSFavouriteScoreCollectionViewController.h"

@interface MUSSplitViewController ()

@end

@implementation MUSSplitViewController

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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    MUSTimelineViewController *timelineController = [storyboard instantiateViewControllerWithIdentifier:@"Timeline"];
    [timelineController setDelegate:self];
    [self setTimelineController:timelineController];
    [self addChildViewController:self.timelineController];
    [self.timelineController didMoveToParentViewController:self];
    [self.timelinePlaceholder addSubview:self.timelineController.view];
    
    MUSDecadeScoreCollectionViewController *decadeScoreCollectionController = [storyboard instantiateViewControllerWithIdentifier:@"DecadeScoreCollection"];
    [self setDecadeScoreCollectionController:decadeScoreCollectionController];
    [self addChildViewController:self.decadeScoreCollectionController];
    [self.decadeScoreCollectionController didMoveToParentViewController:self];
    [self.scoreCollectionPlaceholder addSubview:self.decadeScoreCollectionController.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.timelineController.view setFrame:self.timelinePlaceholder.bounds];
    [self.decadeScoreCollectionController.view setFrame:self.scoreCollectionPlaceholder.bounds];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Timeline Controller Delegate Methods

- (void)timelineController:(MUSTimelineViewController *)controller didSelectDecade:(NSString *)decade
{
    [self.decadeScoreCollectionController setDecade:decade];
}

- (void)timelineControllerDidSelectFavourites:(MUSTimelineViewController *)controller
{
    // show the favourites view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MUSFavouriteScoreCollectionViewController *favouritesViewController = (MUSFavouriteScoreCollectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FavouritesController"];
    [self presentViewController:favouritesViewController animated:YES completion:nil];
}

@end
