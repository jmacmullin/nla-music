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

@interface MUSScoreViewController ()

- (void)toggleChrome:(id)sender;
- (void)hideChrome;
- (void)showChrome;

@property (nonatomic, strong) NSOperationQueue *imageDownloadQueue;

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
    
    NSOperationQueue *imageDownloadQueue = [[NSOperationQueue alloc] init];
    [self setImageDownloadQueue:imageDownloadQueue];
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleChrome:)];
    [self.scorePageScrollView addGestureRecognizer:tapRecognizer];
    
    [self.scorePageScrollView setFrame:self.view.bounds]; // WTF do I need this?
    [self.scorePageScrollView setDataSource:self];
    [self.scorePageScrollView setDelegate:self];
    [self.scorePageScrollView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [MUSScoreViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideChrome) object:nil];
    [self showChrome];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)dismiss:(id)sender
{
    // cancel pending selectors first
    [MUSScoreViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideChrome) object:nil];
    [MUSScoreViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showChrome) object:nil];

    [self.presentingViewController dismissViewControllerAnimated:NO completion:NULL];
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
    }];
}

- (void)showChrome {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolBar setAlpha:1.0];
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

@end
