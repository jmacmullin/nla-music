//
//  MUSComposerCell.m
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

#import "MUSComposerCell.h"

@interface MUSComposerCell()
@property (nonatomic, strong) UIView *barView;
- (void)initialise;
@end

@implementation MUSComposerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    [self addObserver:self forKeyPath:@"composerInfo" options:NSKeyValueObservingOptionNew context:NULL];
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    UIView *barView = [[UIView alloc] initWithFrame:CGRectZero];
    [barView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:229.0/255.0 blue:255.0/255.0 alpha:0.5]];
    [self setBarView:barView];
    [view addSubview:self.barView];
    [self setBackgroundView:view];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"composerInfo"]) {
        [self.composerLabel setText:[self.composerInfo valueForKey:@"creator"]];
        int count = [[self.composerInfo valueForKey:@"count"] intValue];
        [self.countLabel setText:[NSString stringWithFormat:@"%i", count]];
        
        float percent = ((float)count / (float)self.maximumNumberOfScores);
        float barWidth = percent * self.frame.size.width;
        [self.barView setFrame:CGRectMake(0.0, 0.0, barWidth, self.frame.size.height)];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"composerInfo"];
}

@end
