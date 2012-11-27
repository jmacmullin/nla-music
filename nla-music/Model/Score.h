#import "_Score.h"

@interface Score : _Score {}

@property (nonatomic, readonly) NSString *firstLetterOfTitle;
@property (nonatomic, readonly) NSURL *thumbnailURL;
@property (nonatomic, readonly) NSURL *coverURL;
@property (nonatomic, readonly) NSURL *webURL;
@property (nonatomic, readonly) NSString *cacheDirectory;

@end
