//
//  MUSScoreViewController.m
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

#import "MUSScoreViewController.h"
#import "NIPhotoScrollView.h"
#import "Page.h"
#import "AFNetworking.h"
#import "MUSDataController.h"
#import "NLAOpenArchiveController.h"
#import "NLAItemInformation.h"

@interface MUSScoreViewController ()

/**
 Toggle the visibility of the chrome.
 */
- (void)toggleChrome:(id)sender;

/**
 Hide the chrome.
 */
- (void)hideChrome;

/**
 Show the chrome and schedule the hiding of the chrome.
 */
- (void)showChrome;

@property (nonatomic, strong) NSOperationQueue *imageDownloadQueue;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) UIPopoverController *sharePopover;
@property (nonatomic, strong) MUSDataController *dataController;
@property (nonatomic, strong) NLAItemInformation *itemInformation;

@end

@implementation MUSScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self!=nil) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self!=nil) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDataController:[MUSDataController sharedController]];
    
    NSOperationQueue *imageDownloadQueue = [[NSOperationQueue alloc] init];
    [self setImageDownloadQueue:imageDownloadQueue];
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleChrome:)];
    [self.scorePageScrollView addGestureRecognizer:tapRecognizer];
    
    [self.scorePageScrollView setFrame:self.view.bounds]; // WTF do I need this?
    [self.scorePageScrollView setDataSource:self];
    [self.scorePageScrollView setDelegate:self];
    [self.scorePageScrollView reloadData];
    
    [self.favouriteButton setImage:[UIImage imageNamed:@"fav_icon_selected.png"] forState:UIControlStateSelected];
    BOOL isFavourite = [self.dataController isScoreMarkedAsFavourite:self.score];
    if (isFavourite == YES) {
        [self.favouriteButton setSelected:YES];
    } else {
        [self.favouriteButton setSelected:NO];
    }
    
    [self addObserver:self forKeyPath:@"itemInformation" options:NSKeyValueObservingOptionNew context:NULL];
    
    // Request the additional information
    [[NLAOpenArchiveController sharedController] requestDetailsForItemWithIdentifier:self.score.identifier
                                                                             success:^(NLAItemInformation *itemInfo) {
                                                                                 [self setItemInformation:itemInfo];
                                                                             }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [MUSScoreViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideChrome) object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UI Actions

- (IBAction)dismiss:(id)sender
{
    // cancel pending selectors first
    [MUSScoreViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideChrome) object:nil];
    [MUSScoreViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showChrome) object:nil];

    [self.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
}

- (void)share:(id)sender
{
    if (self.coverImage!=nil) {
        UIActivityViewController *activityController;
        activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self.coverImage]
                                                               applicationActivities:nil];
        [activityController setExcludedActivityTypes:@[
         UIActivityTypeAssignToContact,
         UIActivityTypeMessage,
         UIActivityTypePrint,
         UIActivityTypePostToWeibo]];
         
        UIPopoverController *activityPopover = [[UIPopoverController alloc] initWithContentViewController:activityController];
        [activityPopover setDelegate:self];
        [self setSharePopover:activityPopover];
        
        [activityPopover presentPopoverFromRect:((UIButton *)sender).frame
                                         inView:self.additionalInformationView
                       permittedArrowDirections:UIPopoverArrowDirectionDown
                                       animated:YES];
        
        // Cancel the scheduled hiding of the chrome
        [MUSScoreViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideChrome) object:nil];
    }
}

- (IBAction)toggleFavourite:(id)sender
{
    [self.favouriteButton setSelected:!self.favouriteButton.selected];
    if (self.favouriteButton.selected == YES) {
        [self.dataController markScore:self.score asFavourite:YES];
    } else {
        [self.dataController markScore:self.score asFavourite:NO];
    }
}

- (IBAction)viewOnTheWeb:(id)sender
{
    [[UIApplication sharedApplication] openURL:self.score.webURL];
}

#pragma mark - Popover Delegate Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self setSharePopover:nil];
    [self hideChrome];
}


#pragma mark - Private Methods

- (void)toggleChrome:(id)sender {
    // cancel any pending requests
    [MUSScoreViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideChrome) object:nil];
    [MUSScoreViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showChrome) object:nil];
    
    // if it is visible, hide it
    if (self.toolBar.alpha==1.0) {
        [self hideChrome];
    } else {
        [self showChrome];
    }
}

- (void)hideChrome {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.5 animations:^{
        [self.toolBar setAlpha:0.0];
        [self.additionalInformationView setAlpha:0.0];
    }];
}

- (void)showChrome {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolBar setAlpha:1.0];
        if ([self.scorePageScrollView hasPrevious] == NO) {
            [self.additionalInformationView setAlpha:1.0];
        }
    }];
    
    // schedule it to be hidden again after 4 secs
    [self performSelector:@selector(hideChrome) withObject:nil afterDelay:4.0];
}


#pragma mark - NIPhoto Album Scroll View Data Source Methods

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView
{
    int count = [[self.score orderedPages] count];
    return count;
}

- (UIView<NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex
{
    return [self.scorePageScrollView pagingScrollView:pagingScrollView pageViewForIndex:pageIndex];
}

- (UIImage *)photoAlbumScrollView: (NIPhotoAlbumScrollView *)photoAlbumScrollView
                     photoAtIndex: (NSInteger)photoIndex
                        photoSize: (NIPhotoScrollViewPhotoSize *)photoSize
                        isLoading: (BOOL *)isLoading
          originalPhotoDimensions: (CGSize *)originalPhotoDimensions
{    
    Page *page = [[self.score orderedPages] objectAtIndex:photoIndex];
    NSURL *pageUrl = [page imageURL];
    
    // TODO: cache images
    
    // request the high resolution image
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:pageUrl];
    AFImageRequestOperation *imageRequestOperation;
    
    void (^successBlock)(UIImage *);
    successBlock = ^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self.scorePageScrollView didLoadPhoto:image
                                                          atIndex:photoIndex
                                                        photoSize:NIPhotoScrollViewPhotoSizeOriginal];
                           
                           if (photoIndex == 0) {
                               [self setCoverImage:image];
                           }
                           
                       });
    };
    
    imageRequestOperation = [AFImageRequestOperation imageRequestOperationWithRequest:imageRequest
                                                                              success:successBlock];

    // If we're on a retina display iPad, then we're going to need to stretch the image
    if ([UIScreen mainScreen].scale == 2.0) {
        [imageRequestOperation setImageScale:0.5];
    }
    [self.imageDownloadQueue addOperation:imageRequestOperation];
    
    *photoSize = NIPhotoScrollViewPhotoSizeThumbnail;
    *isLoading = YES;

    if (photoIndex == 0) {
        return self.initialImage;
    } else {
        return nil;
    }
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"itemInformation"]) {
        [self.titleLabel setText:self.itemInformation.title];
        [self.creatorLabel setText:self.itemInformation.creator];
        [self.descriptionLabel setText:self.itemInformation.description];
        [self.dateLabel setText:self.itemInformation.date];
        [self.publisherLabel setText:self.itemInformation.publisher];
    }
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"itemInformation"];
}

@end
