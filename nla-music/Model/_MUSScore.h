// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MUSScore.h instead.

#import <CoreData/CoreData.h>


extern const struct MUSScoreAttributes {
	__unsafe_unretained NSString *creator;
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *publisher;
	__unsafe_unretained NSString *title;
} MUSScoreAttributes;

extern const struct MUSScoreRelationships {
	__unsafe_unretained NSString *pages;
} MUSScoreRelationships;

extern const struct MUSScoreFetchedProperties {
	__unsafe_unretained NSString *orderedPages;
} MUSScoreFetchedProperties;

@class MUSPage;







@interface MUSScoreID : NSManagedObjectID {}
@end

@interface _MUSScore : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MUSScoreID*)objectID;




@property (nonatomic, strong) NSString* creator;


//- (BOOL)validateCreator:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* date;


//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* identifier;


//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* publisher;


//- (BOOL)validatePublisher:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* title;


//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* pages;

- (NSMutableSet*)pagesSet;




@property (nonatomic, readonly) NSArray *orderedPages;


@end

@interface _MUSScore (CoreDataGeneratedAccessors)

- (void)addPages:(NSSet*)value_;
- (void)removePages:(NSSet*)value_;
- (void)addPagesObject:(MUSPage*)value_;
- (void)removePagesObject:(MUSPage*)value_;

@end

@interface _MUSScore (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCreator;
- (void)setPrimitiveCreator:(NSString*)value;




- (NSString*)primitiveDate;
- (void)setPrimitiveDate:(NSString*)value;




- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;




- (NSString*)primitivePublisher;
- (void)setPrimitivePublisher:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (NSMutableSet*)primitivePages;
- (void)setPrimitivePages:(NSMutableSet*)value;


@end
