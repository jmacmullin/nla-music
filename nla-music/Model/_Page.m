// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Page.m instead.

#import "_Page.h"

const struct PageAttributes PageAttributes = {
	.identifier = @"identifier",
	.number = @"number",
};

const struct PageRelationships PageRelationships = {
	.score = @"score",
};

const struct PageFetchedProperties PageFetchedProperties = {
};

@implementation PageID
@end

@implementation _Page

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Page" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Page";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Page" inManagedObjectContext:moc_];
}

- (PageID*)objectID {
	return (PageID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"numberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"number"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic identifier;






@dynamic number;



- (int32_t)numberValue {
	NSNumber *result = [self number];
	return [result intValue];
}

- (void)setNumberValue:(int32_t)value_ {
	[self setNumber:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveNumberValue {
	NSNumber *result = [self primitiveNumber];
	return [result intValue];
}

- (void)setPrimitiveNumberValue:(int32_t)value_ {
	[self setPrimitiveNumber:[NSNumber numberWithInt:value_]];
}





@dynamic score;

	






@end
