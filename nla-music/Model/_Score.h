// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Score.h instead.

#import <CoreData/CoreData.h>


extern const struct ScoreAttributes {
	__unsafe_unretained NSString *creator;
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *publisher;
	__unsafe_unretained NSString *title;
} ScoreAttributes;

extern const struct ScoreRelationships {
	__unsafe_unretained NSString *pages;
} ScoreRelationships;

extern const struct ScoreFetchedProperties {
	__unsafe_unretained NSString *orderedPages;
} ScoreFetchedProperties;

@class Page;







@interface ScoreID : NSManagedObjectID {}
@end

@interface _Score : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ScoreID*)objectID;




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

@interface _Score (CoreDataGeneratedAccessors)

- (void)addPages:(NSSet*)value_;
- (void)removePages:(NSSet*)value_;
- (void)addPagesObject:(Page*)value_;
- (void)removePagesObject:(Page*)value_;

@end

@interface _Score (CoreDataGeneratedPrimitiveAccessors)


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
