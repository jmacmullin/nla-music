// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Score.m instead.

#import "_Score.h"

const struct ScoreAttributes ScoreAttributes = {
	.creator = @"creator",
	.date = @"date",
	.identifier = @"identifier",
	.publisher = @"publisher",
	.sortTitle = @"sortTitle",
	.title = @"title",
};

const struct ScoreRelationships ScoreRelationships = {
	.pages = @"pages",
};

const struct ScoreFetchedProperties ScoreFetchedProperties = {
	.orderedPages = @"orderedPages",
};

@implementation ScoreID
@end

@implementation _Score

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Score" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Score";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Score" inManagedObjectContext:moc_];
}

- (ScoreID*)objectID {
	return (ScoreID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic creator;






@dynamic date;






@dynamic identifier;






@dynamic publisher;






@dynamic sortTitle;






@dynamic title;






@dynamic pages;

	
- (NSMutableSet*)pagesSet {
	[self willAccessValueForKey:@"pages"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"pages"];
  
	[self didAccessValueForKey:@"pages"];
	return result;
}
	



@dynamic orderedPages;




@end
