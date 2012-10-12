#import "_Score.h"

@interface Score : _Score {}

@property (nonatomic, readonly) NSString *firstLetterOfTitle;
@property (nonatomic, readonly) NSURL *thumbnailURL;
@property (nonatomic, readonly) NSURL *coverURL;

@end
