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

@interface MUSDataController()

@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSManagedObjectContext *context;

//TODO: Consider lazily loading the scores
@property (nonatomic, strong) NSArray *scores;

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

- (int)numberOfScores {
    if (self.scores == nil) {
        NSFetchRequest *allScoresFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Score"];
        NSSortDescriptor *titleSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        [allScoresFetchRequest setSortDescriptors:@[titleSortDescriptor]];
        NSArray *allScores = [self.context executeFetchRequest:allScoresFetchRequest error:NULL]; //TODO: Error handling
        [self setScores:allScores];
    }
    return self.scores.count;
}

- (Score *)scoreAtIndex:(NSIndexPath *)indexPath
{
    Score *score = [self.scores objectAtIndex:indexPath.row];
    return score;
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
        
        // copy the core-data database to a temporary directory if it isn't already there
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

@end
