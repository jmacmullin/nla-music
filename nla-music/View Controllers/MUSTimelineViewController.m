//
//  MUSTimelineViewController.m
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

#import "MUSTimelineViewController.h"
#import "MUSDecadeScoreCollectionViewController.h"
#import "MUSDataController.h"
#import <QuartzCore/QuartzCore.h>

// the number of pages the timeline will fill
static int kNumberOfPagesInScrollView = 4;

// as the height of each decade is based on the number of scores
// published in that decade, we need a minimum number so that decades
// with few scores are still tappable.
static int kMinimumNumberOfScoresPerDecadeForDisplay = 100;

// the height of the favourites section
static float kFavouritesSectionHeight = 88.0;

static NSString * kShowIndexSegueIdentifier = @"ShowIndex";

@interface MUSTimelineViewController ()

@property (nonatomic, strong) MUSDataController *dataController;
@property (nonatomic, strong) NSString *selectedDecade;

- (void)createTimeline;
- (void)selectDecade:(UIGestureRecognizer *)gesture;

@end

@implementation MUSTimelineViewController

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
    [self createTimeline];
    [self.favouritesSectionView setFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 0.0)];
    [self.favouritesSectionView setAlpha:0.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    // expand or collapse the favourites section
    // if there are any favourites, then display a favourites section
    CGRect favouritesSectionFrame;
    CGRect timelineFrame;
    int numberOfFavourites = [self.dataController numberOfFavouriteScores];
    
    if (numberOfFavourites > 0 && self.favouritesSectionView.superview == nil) {
        favouritesSectionFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, kFavouritesSectionHeight);
        timelineFrame = CGRectMake(0.0, kFavouritesSectionHeight, self.view.frame.size.width, self.view.frame.size.height - kFavouritesSectionHeight);
        [self.view addSubview:self.favouritesSectionView];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.favouritesSectionView setFrame:favouritesSectionFrame];
                             [self.timelineScrollview setFrame:timelineFrame];
                             [self.favouritesSectionView setAlpha:1.0];
                         }];
        
    } else if (numberOfFavourites == 0 && self.favouritesSectionView.superview != nil) {
        favouritesSectionFrame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 0.0);
        timelineFrame = self.view.bounds;
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.favouritesSectionView setFrame:favouritesSectionFrame];
                             [self.timelineScrollview setFrame:timelineFrame];
                             [self.favouritesSectionView setAlpha:0.0];
                         }
                         completion:^(BOOL finished) {
                             [self.favouritesSectionView removeFromSuperview];
                         }];
    }

}

- (void)createTimeline
{
    // draw a view for each decade whose height is relative to
    // the number of items published in that decade
    
    float topMargin = 0.0;
    float leftMargin = 0.0;
    int totalNumber = 0;
    
    CGRect timelineFrame = self.view.bounds;
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:timelineFrame];
    [scrollview setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * kNumberOfPagesInScrollView)];
    
    NSArray *decades = [self.dataController decadesInWhichMusicWasPublished];
    for (NSDictionary *dict in decades) {
        
        if ([dict valueForKey:@"date"]!=nil) {
            int count = [[dict valueForKey:@"count"] intValue];
            if (count > kMinimumNumberOfScoresPerDecadeForDisplay) {
                totalNumber += count;
            } else {
                totalNumber += kMinimumNumberOfScoresPerDecadeForDisplay;
            }
        }
        
    }
    
    int decadeIndex = 0;
    
    for (NSDictionary *dict in decades) {
        
        NSString *decade = [dict valueForKey:@"date"];
        
        if (decade!=nil) {
            
            int numberInDecade = [[dict valueForKey:@"count"] intValue];
            if (numberInDecade < kMinimumNumberOfScoresPerDecadeForDisplay) {
                numberInDecade = kMinimumNumberOfScoresPerDecadeForDisplay;
            }
            
            float height =  ( (float)numberInDecade / (float)totalNumber)
                              * (self.view.bounds.size.height * kNumberOfPagesInScrollView);
            CGRect frame = CGRectMake(leftMargin, topMargin,  self.view.frame.size.width, height);
            
            UIView *view = [[UIView alloc] initWithFrame:frame];
            
            UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:[UIColor whiteColor]];
            [label setText:decade];
            [label setBackgroundColor:[UIColor clearColor]];
            [view addSubview:label];
            [view setTag:decadeIndex]; // ARGHH, I hate using tags, but not sure this is worth a custom view
            
            UITapGestureRecognizer *tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDecade:)];
            [view addGestureRecognizer:tapRecogniser];
            
            CALayer *layer = view.layer;
            [layer setBorderColor:[[UIColor blackColor] CGColor]];
            [layer setBorderWidth:1.0];
            [scrollview addSubview:view];
            topMargin += height;

        }
        
        decadeIndex++;
    }
    
    [self setTimelineScrollview:scrollview];
    [self.view addSubview:scrollview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showFavourites:(id)sender
{
    [self performSegueWithIdentifier:@"ShowFavourites" sender:self];
}

- (void)selectDecade:(UIGestureRecognizer *)gesture
{
    int indexOfSelectedDecade = gesture.view.tag; // ARGHH, I hate using tags, but not sure this is worth a custom view
    NSDictionary *decadeInfo = [self.dataController decadesInWhichMusicWasPublished][indexOfSelectedDecade];
    [self setSelectedDecade:[decadeInfo valueForKey:@"date"]];
    [self performSegueWithIdentifier:kShowIndexSegueIdentifier sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kShowIndexSegueIdentifier]) {
        MUSDecadeScoreCollectionViewController *indexController = (MUSDecadeScoreCollectionViewController *)segue.destinationViewController;
        [indexController setDecade:self.selectedDecade];
    }
}

@end
