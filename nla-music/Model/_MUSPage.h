// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MUSPage.h instead.

#import <CoreData/CoreData.h>


extern const struct MUSPageAttributes {
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *number;
} MUSPageAttributes;

extern const struct MUSPageRelationships {
	__unsafe_unretained NSString *score;
} MUSPageRelationships;

extern const struct MUSPageFetchedProperties {
} MUSPageFetchedProperties;

@class MUSScore;




@interface MUSPageID : NSManagedObjectID {}
@end

@interface _MUSPage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MUSPageID*)objectID;




@property (nonatomic, strong) NSString* identifier;


//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* number;


@property int32_t numberValue;
- (int32_t)numberValue;
- (void)setNumberValue:(int32_t)value_;

//- (BOOL)validateNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) MUSScore* score;

//- (BOOL)validateScore:(id*)value_ error:(NSError**)error_;





@end

@interface _MUSPage (CoreDataGeneratedAccessors)

@end

@interface _MUSPage (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;




- (NSNumber*)primitiveNumber;
- (void)setPrimitiveNumber:(NSNumber*)value;

- (int32_t)primitiveNumberValue;
- (void)setPrimitiveNumberValue:(int32_t)value_;





- (MUSScore*)primitiveScore;
- (void)setPrimitiveScore:(MUSScore*)value;


@end
