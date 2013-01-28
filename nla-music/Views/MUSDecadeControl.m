//
//  MUSDecadeControl.m
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

#import "MUSDecadeControl.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+NLAMusicColors.h"

@interface MUSDecadeControl()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MUSDecadeControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self!=nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        [label setShadowColor:[UIColor whiteColor]];
        [label setShadowOffset:CGSizeMake(0.0, 1.0)];
        [label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:label];
        
        [self setLabel:label];
    }
    return self;
}

- (void)itemLabelNeedsDisplay
{
    //[self.label setText:self.itemLabel];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected == YES) {
        // darken the label shadow
        [self.label setShadowColor:[UIColor nlaMusicTimelineSelectedItemGradientStartColor]];
        
    } else {
        // lighten the label shadow
        [self.label setShadowColor:[UIColor whiteColor]];        
    }
}

@end
