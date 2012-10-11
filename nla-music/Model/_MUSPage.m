// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MUSPage.m instead.

#import "_MUSPage.h"

const struct MUSPageAttributes MUSPageAttributes = {
	.identifier = @"identifier",
	.number = @"number",
};

const struct MUSPageRelationships MUSPageRelationships = {
	.score = @"score",
};

const struct MUSPageFetchedProperties MUSPageFetchedProperties = {
};

@implementation MUSPageID
@end

@implementation _MUSPage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MUSPage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MUSPage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MUSPage" inManagedObjectContext:moc_];
}

- (MUSPageID*)objectID {
	return (MUSPageID*)[super objectID];
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
