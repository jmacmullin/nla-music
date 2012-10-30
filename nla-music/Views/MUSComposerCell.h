//
//  MUSComposerCell.h
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

@interface MUSComposerCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *composerLabel;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;


/**
 A dictionary containing information about the
 composer. The dictionary should contain two values:
 - creator, a String with the composer's name
 - count, an int representing the number of scores for
   the composer in the given context (eg decade).
 */
@property (nonatomic, strong) NSDictionary *composerInfo;

/**
 The maximum number of scores created by any composer
 in the given context (eg decade) so this cell can
 represent the current composer's count as a percentage
 of the largest count.
 */
@property (nonatomic) int maximumNumberOfScores;

@end
