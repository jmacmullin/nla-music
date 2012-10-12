//
//  MUSScoreCell.m
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

#import "MUSScoreCell.h"

@interface MUSScoreCell()
- (void)initialise;
@end

@implementation MUSScoreCell

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
    [self addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        // set a place-holder image
        [self.imageView setImage:[UIImage imageNamed:@"thumbnail_placeholder"]];
        
        // update the details of the score
        [self.imageView setPathToNetworkImage:[self.score.thumbnailURL absoluteString]];
        [self.titleLabel setText:self.score.title];
    }
}

- (void)prepareForReuse
{
    // cancel any pending network image request
    [self.imageView prepareForReuse];
    
    // reset the UI
    [self.titleLabel setText:@""];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"score"];
}

@end
