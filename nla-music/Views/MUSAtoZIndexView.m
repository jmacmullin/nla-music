//
//  MUSAtoZIndexView.m
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

#import "MUSAtoZIndexView.h"
#import <QuartzCore/QuartzCore.h>

static float kPadding = 22.0;

@interface MUSAtoZIndexView()

@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, strong) NSMutableArray *letterViews;
@property (nonatomic) int indexOfLastLetter;

- (void)initialise;
- (void)notifyDelegateOfTouchedLetterWithTouches:(NSSet *)touches;

@end

@implementation MUSAtoZIndexView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self!=nil) {
        [self initialise];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self!=nil) {
        [self initialise];
    }
    return self;
}

- (void)initialise
{
    NSArray *letters = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I",
    @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S",
    @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    [self setLetters:letters];
    
    // background
    CALayer *layer = self.layer;
    [layer setCornerRadius:20.0];
    [self.layer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [self setIndexOfLastLetter:-1];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.letterViews == nil) {
        [self setLetterViews:[NSMutableArray arrayWithCapacity:26]];
        for (int i=0;i<26;i++) {
            UILabel *letterLabel = [[UILabel alloc] init];
            [letterLabel setTextAlignment:NSTextAlignmentCenter];
            [letterLabel setText:self.letters[i]];
            [letterLabel setTextColor:[UIColor whiteColor]];
            [letterLabel setBackgroundColor:[UIColor clearColor]];
            [self.letterViews addObject:letterLabel];
            [self addSubview:letterLabel];
        }
    }
    
    for (int i=0;i<26;i++) {
        UILabel *letterLabel = self.letterViews[i];
        float height = (self.frame.size.height - 2.0 * kPadding) / 26.0;
        [letterLabel setFrame:CGRectMake(0.0, (i * height) + kPadding, self.frame.size.width, height)];
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self notifyDelegateOfTouchedLetterWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self notifyDelegateOfTouchedLetterWithTouches:touches];
}

- (void)notifyDelegateOfTouchedLetterWithTouches:(NSSet *)touches
{
    [self.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:0.5] CGColor]];
    
    // get a touch
    UITouch *touch = [touches anyObject]; // not dealing with multiple touches
    
    // get the position of the touch within the view
    CGPoint touchPoint = [touch locationInView:self];
    float touchHeight = fmax(touchPoint.y, 0.0);
    touchHeight = fmin(touchHeight, self.frame.size.height);
    
    // get the closest letter
    int letterIndex = (int)((touchHeight / self.frame.size.height) * 25.0);
    
    if (self.indexOfLastLetter != letterIndex) {
        NSString *letter = self.letters[letterIndex];
        [self setIndexOfLastLetter:letterIndex];
        if (self.delegate!=nil && [self.delegate conformsToProtocol:@protocol(MUSAtoZIndexDelegate)]) {
            [self.delegate indexViewDidSelectLetterInIndex:letter];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.layer setBackgroundColor:[[UIColor clearColor] CGColor]];
}

@end
