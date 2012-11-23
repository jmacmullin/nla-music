//
//  MUSScoreViewController.h
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

#import <UIKit/UIKit.h>
#import "NINetworkImageView.h"
#import "NIPhotoAlbumScrollView.h"
#import "NIPhotoScrubberView.h"
#import "Score.h"

@interface MUSScoreViewController : UIViewController <NIPhotoAlbumScrollViewDataSource, NIPhotoAlbumScrollViewDelegate, UIPopoverControllerDelegate, NIPhotoScrubberViewDataSource, NIPhotoScrubberViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIImage *initialImage;
@property (nonatomic, strong) IBOutlet UIToolbar *toolBar;
@property (nonatomic, strong) IBOutlet UIButton *darkInfoButton;
@property (nonatomic, strong) IBOutlet UIButton *lightInfoButton;
@property (nonatomic, strong) IBOutlet NIPhotoAlbumScrollView *scorePageScrollView;

@property (nonatomic, strong) IBOutlet UIView *additionalInformationView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinny;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *creatorLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UIButton *favouriteButton;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *publisherLabel;

@property (nonatomic, strong) IBOutlet NIPhotoScrubberView *scrubberView;


@property (nonatomic, strong) Score *score;

- (IBAction)dismiss:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)toggleFavourite:(id)sender;
- (IBAction)viewOnTheWeb:(id)sender;
/**
 Toggle the visibility of the chrome.
 */
- (IBAction)toggleChrome:(id)sender;


@end
