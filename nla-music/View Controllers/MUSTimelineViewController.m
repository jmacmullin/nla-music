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
#import "MUSDecadeControl.h"
#import "MUSFavouritesControl.h"

// the number of pages the timeline will fill
static int kNumberOfPagesInScrollView = 4;

// as the height of each decade is based on the number of scores
// published in that decade, we need a minimum number so that decades
// with few scores are still tappable.
static int kMinimumNumberOfScoresPerDecadeForDisplay = 200;
static int kMaximumNumberOfScoresPerDecadeForDisplay = 1200;

// the height of the favourites section
static float kFavouritesSectionHeight = 88.0;

static NSString * kShowIndexSegueIdentifier = @"ShowIndex";

@interface MUSTimelineViewController ()

@property (nonatomic, strong) MUSDataController *dataController;
@property (nonatomic, strong) NSString *selectedDecade;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) MUSDecadeControl *selectedDecadeControl;

- (void)createTimeline;
- (void)selectDecade:(id)sender;

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
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self createTimeline];    
}


- (void)viewDidAppear:(BOOL)animated
{
    if (self.selectedDecadeControl == nil) {
        MUSTimelineItemControl *itemControl = (MUSTimelineItemControl *)self.scrollview.subviews[6];
        [itemControl sendActionsForControlEvents:UIControlEventTouchDown];
    }
}

- (void)viewWillLayoutSubviews
{
    [self.scrollview setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * kNumberOfPagesInScrollView)];
}

- (void)createTimeline
{
    // draw a view for each decade whose height is relative to
    // the number of items published in that decade
    
    float topMargin = kFavouritesSectionHeight;
    float leftMargin = 0.0;
    int totalNumber = 0;
    
    CGRect timelineFrame = self.view.bounds;
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:timelineFrame];
    [self setScrollview:scrollview];
    [scrollview setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    MUSFavouritesControl *favouritesItem = [[MUSFavouritesControl alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, kFavouritesSectionHeight)];
    [favouritesItem setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [favouritesItem addTarget:self action:@selector(showFavourites:) forControlEvents:UIControlEventTouchDown];
    [self.scrollview addSubview:favouritesItem];
    
    NSArray *decades = [self.dataController decadesInWhichMusicWasPublished];
    for (NSDictionary *dict in decades) {
        
        if ([dict valueForKey:@"date"]!=nil) {
            int count = [[dict valueForKey:@"count"] intValue];
            if (count > kMaximumNumberOfScoresPerDecadeForDisplay) {
                totalNumber += kMaximumNumberOfScoresPerDecadeForDisplay;
            } else if (count > kMinimumNumberOfScoresPerDecadeForDisplay) {
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
            if (numberInDecade > kMaximumNumberOfScoresPerDecadeForDisplay) {
                numberInDecade = kMaximumNumberOfScoresPerDecadeForDisplay;
            } else if (numberInDecade < kMinimumNumberOfScoresPerDecadeForDisplay) {
                numberInDecade = kMinimumNumberOfScoresPerDecadeForDisplay;
            }
            
            float height =  ((float)numberInDecade / (float)totalNumber)
                              * ((self.view.bounds.size.height * kNumberOfPagesInScrollView) - kFavouritesSectionHeight) ;
            
            CGRect frame = CGRectMake(leftMargin, topMargin,  self.view.frame.size.width, height);
            
            MUSDecadeControl *decadeControl = [[MUSDecadeControl alloc] initWithFrame:frame];
            [decadeControl setItemLabel:decade];
            [decadeControl addTarget:self action:@selector(selectDecade:) forControlEvents:UIControlEventTouchDown];
            [decadeControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            
            [scrollview addSubview:decadeControl];
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
    if (self.delegate!=nil && [self.delegate conformsToProtocol:@protocol(MUSTimelineViewControllerDelegate)]) {
        [self.delegate timelineControllerDidSelectFavourites:self];
    }
}

- (void)selectDecade:(id)sender
{
    if (self.selectedDecadeControl == sender) {
        return;
    }
    
    if (self.selectedDecadeControl!=nil) {
        [self.selectedDecadeControl setSelected:NO];
    }
    
    MUSDecadeControl *decadeControl = (MUSDecadeControl *)sender;
    [self setSelectedDecadeControl:decadeControl];
    [decadeControl setSelected:YES];
    
    NSString *decade = decadeControl.itemLabel;
    [self setSelectedDecade:decade];
    if (self.delegate!=nil && [self.delegate conformsToProtocol:@protocol(MUSTimelineViewControllerDelegate)]) {
        [self.delegate timelineController:self didSelectDecade:self.selectedDecade];
    }
}

@end
