//
//  MUSTimelineItemControl.m
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

#import "MUSTimelineItemControl.h"
#import "UIColor+NLAMusicColors.h"
#import <QuartzCore/QuartzCore.h>

@interface MUSTimelineItemControl()

@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CALayer *innerShadowLayer;

@end

@implementation MUSTimelineItemControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self!=nil) {
        
        [self addObserver:self forKeyPath:@"itemLabel" options:NSKeyValueObservingOptionNew context:NULL];
        
        CALayer *layer = self.layer;
        [layer setMasksToBounds:YES];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        [gradientLayer setFrame:CGRectMake(0.0, 1.0, layer.bounds.size.width, layer.bounds.size.height - 2.0)];
        
        [gradientLayer setColors:@[(id)[[UIColor nlaMusicTimelineItemGradientStartColor] CGColor],
         (id)[[UIColor nlaMusicTimelineItemGradientEndColor] CGColor]]];
        [layer addSublayer:gradientLayer];
        [self setGradientLayer:gradientLayer];
        
        CALayer *noiseLayer = [CALayer layer];
        [noiseLayer setFrame:gradientLayer.bounds];
        [noiseLayer setBackgroundColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"noise.png"]] CGColor]];
        [layer addSublayer:noiseLayer];
        
        CALayer *topLineLayer = [CALayer layer];
        [topLineLayer setFrame:CGRectMake(0.0, 0.0, layer.frame.size.width, 1.0)];
        [topLineLayer setBackgroundColor:[[UIColor nlaMusicHighlightColor] CGColor]];
        [layer addSublayer:topLineLayer];
        [self setTopLine:topLineLayer];
        
        CALayer *bottomLineLayer = [CALayer layer];
        [bottomLineLayer setFrame:CGRectMake(0.0, layer.frame.size.height - 1.0, layer.frame.size.width, 1.0)];
        [bottomLineLayer setBackgroundColor:[[UIColor nlaMusicLowlightColor] CGColor]];
        [layer addSublayer:bottomLineLayer];        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"itemLabel"]) {
        [self itemLabelNeedsDisplay];
    }
}

- (void)itemLabelNeedsDisplay
{
    // This method has been intentionally left blank. Subclasses should override it to do something sensible.
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected == YES) {
        // darken the top line
        [self.topLine setBackgroundColor:[[UIColor nlaMusicTimelineSelectedItemGradientStartColor] CGColor]];
        
        // add an inner shadow
        if (self.innerShadowLayer==nil) {
            CAShapeLayer *shadowLayer = [CAShapeLayer layer];
            [shadowLayer setFrame:self.bounds];
            [shadowLayer setShadowColor:[[UIColor nlaMusicLowlightColor] CGColor]];
            [shadowLayer setShadowOffset:CGSizeZero];
            [shadowLayer setShadowOpacity:0.75f];
            [shadowLayer setShadowRadius:15.0f];
            [shadowLayer setFillRule:kCAFillRuleEvenOdd];
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, CGRectInset(self.bounds, 0.0, -42.0));
            CGPathRef innerPath = [[UIBezierPath bezierPathWithRect:shadowLayer.bounds] CGPath];
            CGPathAddPath(path, NULL, innerPath);
            [shadowLayer setPath:path];
            CGPathRelease(path);
            
            [self setInnerShadowLayer:shadowLayer];
        }
        
        [self.layer addSublayer:self.innerShadowLayer];
        
        // darken the gradient
        [self.gradientLayer setColors:@[(id)[[UIColor nlaMusicTimelineSelectedItemGradientStartColor] CGColor],
         (id)[[UIColor nlaMusicTimelineSelectedItemGradientEndColor] CGColor]]];
    } else {
        // lighten the top line
        [self.topLine setBackgroundColor:[[UIColor nlaMusicHighlightColor] CGColor]];
        
        // remove the inner shadow
        [self.innerShadowLayer removeFromSuperlayer];
        
        // lighten the gradient
        [self.gradientLayer setColors:@[(id)[[UIColor nlaMusicTimelineItemGradientStartColor] CGColor],
         (id)[[UIColor nlaMusicTimelineItemGradientEndColor] CGColor]]];
        
    }
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"itemLabel"];
}

@end
