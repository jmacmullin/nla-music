// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Page.h instead.

#import <CoreData/CoreData.h>


extern const struct PageAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *number;
} PageAttributes;

extern const struct PageRelationships {
	__unsafe_unretained NSString *score;
} PageRelationships;

extern const struct PageFetchedProperties {
} PageFetchedProperties;

@class Score;




@interface PageID : NSManagedObjectID {}
@end

@interface _Page : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PageID*)objectID;




@property (nonatomic, strong) NSString* identifier;


//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* number;


@property int32_t numberValue;
- (int32_t)numberValue;
- (void)setNumberValue:(int32_t)value_;

//- (BOOL)validateNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Score* score;

//- (BOOL)validateScore:(id*)value_ error:(NSError**)error_;





@end

@interface _Page (CoreDataGeneratedAccessors)

@end

@interface _Page (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;




- (NSNumber*)primitiveNumber;
- (void)setPrimitiveNumber:(NSNumber*)value;

- (int32_t)primitiveNumberValue;
- (void)setPrimitiveNumberValue:(int32_t)value_;





- (Score*)primitiveScore;
- (void)setPrimitiveScore:(Score*)value;


@end
