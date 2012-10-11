// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MUSScore.m instead.

#import "_MUSScore.h"

const struct MUSScoreAttributes MUSScoreAttributes = {
	.creator = @"creator",
	.date = @"date",
	.identifier = @"identifier",
	.publisher = @"publisher",
	.title = @"title",
};

const struct MUSScoreRelationships MUSScoreRelationships = {
	.pages = @"pages",
};

const struct MUSScoreFetchedProperties MUSScoreFetchedProperties = {
	.orderedPages = @"orderedPages",
};

@implementation MUSScoreID
@end

@implementation _MUSScore

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MUSScore" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MUSScore";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MUSScore" inManagedObjectContext:moc_];
}

- (MUSScoreID*)objectID {
	return (MUSScoreID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic creator;






@dynamic date;






@dynamic identifier;






@dynamic publisher;






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
