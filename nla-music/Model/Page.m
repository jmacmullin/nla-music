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


#import "Page.h"
#import "Score.h"

@implementation Page

- (NSURL *)imageURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://nla.gov.au/%@-e", [self identifier]]];
}

- (NSURL *)thumbnailURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://nla.gov.au/%@-t", [self identifier]]];
}

- (NSString *)cachedImagePath {
    NSString *cachedImagePath = [self.score.cacheDirectory stringByAppendingPathComponent:self.identifier];
    cachedImagePath = [cachedImagePath stringByAppendingPathExtension:@"jpg"];
    return cachedImagePath;
}

- (NSString *)cachedThumbnailImagePath {
    NSString *cachedThumbnailPath = [self.score.cacheDirectory stringByAppendingPathComponent:self.identifier];
    cachedThumbnailPath = [cachedThumbnailPath stringByAppendingString:@"-t"];
    cachedThumbnailPath = [cachedThumbnailPath stringByAppendingPathExtension:@"jpg"];
    return cachedThumbnailPath;
}

@end
