//
//  MUSDataController.m
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

#import "MUSDataController.h"
#import <CoreData/CoreData.h>

static NSString * kFavouritesKey = @"favourite-scores";

@interface MUSDataController()

@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) NSArray *cachedDecades;

@property (nonatomic, strong) NSString *decadeOfCachedScores;
@property (nonatomic, strong) NSArray *cachedScores;

- (NSArray *)fetchDecades;
- (NSArray *)fetchIdentifiersOfFavourites;

@end

@implementation MUSDataController

+ (MUSDataController *)sharedController
{
    static MUSDataController *sharedInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (Score *)scoreAtIndex:(NSIndexPath *)indexPath inDecade:(NSString *)decade
{
    if ([self.decadeOfCachedScores isEqualToString:decade] && self.cachedScores!=nil) {
        return [self.cachedScores objectAtIndex:indexPath.row];
    }
    
    NSFetchRequest *scoresFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Score"];
    
    // Sort order
    NSSortDescriptor *titleSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [scoresFetchRequest setSortDescriptors:@[titleSortDescriptor]];
    
    // Only get scores for the given decade
    NSPredicate *decadePredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"date", decade, nil];
    [scoresFetchRequest setPredicate:decadePredicate];
    
    NSArray *scores = [self.context executeFetchRequest:scoresFetchRequest error:NULL]; // TODO: Error handling
    [self setCachedScores:scores];
    [self setDecadeOfCachedScores:decade];
    
    return [self.cachedScores objectAtIndex:indexPath.row];
}

#pragma mark - Core Data Stack

- (NSManagedObjectContext *)context {
    if (_context == nil) {
        // Create the managed object model
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        [self setModel:model];
        
        // Create the persistent store coordinator
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        [self setCoordinator:coordinator];
        
        // Create the persistent store itself (if it is not already there)
        
        // copy the core-data database to the documents directory if it isn't already there
        BOOL expandTilde = YES;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, expandTilde);
        NSString *documentPath = [paths objectAtIndex:0];
        NSString *dataStorePath = [documentPath stringByAppendingPathComponent:@"data.sqlite"];
        NSURL *storeURL = [[NSURL alloc] initFileURLWithPath:dataStorePath];
        BOOL isDir = NO;
        NSError *error;
        if (! [[NSFileManager defaultManager] fileExistsAtPath:dataStorePath isDirectory:&isDir] && isDir == NO) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:&error];
            NSURL *bundleURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"sqlite"]];
            NSError *error;
            [[NSFileManager defaultManager] copyItemAtURL:bundleURL toURL:storeURL error:&error];
        }
        
        NSError *storeError;
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                       configuration:nil
                                                 URL:storeURL
                                             options:nil
                                               error:&storeError]) {
            NSLog(@"There was an error creating the persistent store");
        }
        
        // Create the context
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context setPersistentStoreCoordinator:self.coordinator];
        
        // Get the 'score' entity from the model and specify the sort order for the
        // 'orderedPages' fetched property
        NSEntityDescription *scoreEntityDescription = [NSEntityDescription entityForName:@"Score" inManagedObjectContext:context];
        NSFetchedPropertyDescription *orderedPagesDescription = [[scoreEntityDescription propertiesByName] objectForKey:@"orderedPages"];
        
        NSFetchRequest *fetchRequest = orderedPagesDescription.fetchRequest;
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES]]];
        
        [self setContext:context];
    }
    return _context;
}

- (NSArray *)fetchDecades
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Score"];
    
    NSEntityDescription *scoreEntityDescription = [NSEntityDescription entityForName:@"Score" inManagedObjectContext:self.context];
    NSAttributeDescription *dateAttributeDescription = [scoreEntityDescription.attributesByName valueForKey:@"date"];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"title"];
    NSExpression *countExpression = [NSExpression expressionForFunction:@"count:" arguments:@[keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"count"];
    [expressionDescription setExpression:countExpression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    
    [fetchRequest setPropertiesToFetch:@[dateAttributeDescription, expressionDescription]];
    [fetchRequest setPropertiesToGroupBy:@[dateAttributeDescription]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[dateSortDescriptor]];
    
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:NULL];
    [self setCachedDecades:results];
    return results;
}

- (NSArray *)decadesInWhichMusicWasPublished
{
    if (self.cachedDecades != nil) {
        return self.cachedDecades;
    }
    
    NSArray *results = [self fetchDecades];
    return results;
}

- (int)numberOfScoresInDecade:(NSString *)decade
{
    NSArray *decades;
    if (self.cachedDecades!=nil) {
        decades = self.cachedDecades;
    } else {
        decades = [self fetchDecades];
    }
    
    for (NSDictionary *dict in decades) {
        if ([[dict valueForKey:@"date"] isEqualToString:decade]) {
            return [[dict valueForKey:@"count"] intValue];
        }
    }
    
    return 0;
}

- (NSArray *)fetchIdentifiersOfFavourites
{
    // TODO: consider caching the list of favourites instead of querying the user defaults
    // each time.

    NSArray *favourites;
    NSString *identifiersOfFavouriteScores = [[NSUserDefaults standardUserDefaults] stringForKey:kFavouritesKey];
    if (identifiersOfFavouriteScores!=nil) {
        favourites = [identifiersOfFavouriteScores componentsSeparatedByString:@","];
    } else {
        favourites = @[];
    }
    return favourites;
}


- (BOOL)isScoreMarkedAsFavourite:(Score *)score
{
    for (NSString *identifier in [self fetchIdentifiersOfFavourites]) {
        if ([identifier isEqualToString:score.identifier]) {
            return YES;
        }
    }
    return NO;
}


- (void)markScore:(Score *)score asFavourite:(BOOL)isFavourite
{
    NSMutableArray *modifiedFavourites = [[self fetchIdentifiersOfFavourites] mutableCopy];
    
    if (isFavourite == YES) {
        // if we're marking the score as a favourite, we'll need to add its
        // identifier to the list of identifiers.
        if ([self isScoreMarkedAsFavourite:score] == NO) {
            [modifiedFavourites addObject:score.identifier];
        }
    } else {
        // otherwise, we'll need to remove its identifier from the list
        if ([self isScoreMarkedAsFavourite:score] == YES) {
            
            NSString *identifierToRemove = nil;
            
            for (NSString *identifier in modifiedFavourites) {
                if ([identifier isEqualToString:score.identifier]) {
                    identifierToRemove = identifier;
                }
            }
            
            if (identifierToRemove!=nil) {
                [modifiedFavourites removeObject:identifierToRemove];
            }
        }
    }
    
    // Save the modified list of favourites
    NSMutableString *identifiersString = [[NSMutableString alloc] init];
    for (NSString *identifier in modifiedFavourites) {
        [identifiersString appendString:identifier];
        if (modifiedFavourites.lastObject!=identifier) {
            [identifiersString appendString:@","];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:identifiersString forKey:kFavouritesKey];
}


@end
