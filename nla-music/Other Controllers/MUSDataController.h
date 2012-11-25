//
//  MUSDataController.h
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

#import <Foundation/Foundation.h>
#import "Score.h"

/**
 Provides access to the sheet music collection.
 */
@interface MUSDataController : NSObject

/**
 Returns the shared data controller.
 */
+ (MUSDataController *)sharedController;

/**
 Returns the index path of the first score in the collection
 whose sort title starts with the given letter.
 */
- (NSIndexPath *)indexOfFirstScoreWithLetter:(NSString *)letter inDecade:(NSString *)decade;

/**
 Returns the score for the given index path in the given decade.
 */
- (Score *)scoreAtIndex:(NSIndexPath *)indexPath inDecade:(NSString *)decade;

/**
 Returns the score for the given index path in the given decade by the given composer.
 */
- (Score *)scoreAtIndex:(NSIndexPath *)indexPath inDecade:(NSString *)decade byComposer:(NSString *)composer;

/**
 Returns an array of dictionaries with information
 about the music that was published in each decade.
 The dictionaries contain two keys:
 - decade (a String with the decade in which the music was published)
 - count (the number of scores in the collection for the given decade).
 */
- (NSArray *)decadesInWhichMusicWasPublished;

/**
 Returns the number of scores published in the given decade.
 */
- (int)numberOfScoresInDecade:(NSString *)decade;

/**
 Returns the number of scores published in the given decade by the given
 composer.
 */
- (int)numberOfScoresInDecade:(NSString *)decade byComposer:(NSString *)composer;

/**
 Returns an array of dictionaries with information
 about the composers who wrote music in the given
 decade.
 The dictionaries contain two keys:
 - composer (a String with the composer's name)
 - count (the number of scores in the collection for
   the given decade for that composer)
 */
- (NSArray *)composersWithMusicPublishedIn:(NSString *)decade;

/**
 Returns the number of scores that have been marked as a favourite.
 */
- (int)numberOfFavouriteScores;

/**
 Returns the score for the given index in the collection of 
 favourite scores.
 */
- (Score *)scoreAtIndexInFavourites:(int)index;

/**
 Returns a BOOL to indicate whether the given score
 has been marked as a favourite or not.
 */
- (BOOL)isScoreMarkedAsFavourite:(Score *)score;

/**
 Marks the given score as a favourite or not.
 */
- (void)markScore:(Score *)score asFavourite:(BOOL)isFavourite;

@end
