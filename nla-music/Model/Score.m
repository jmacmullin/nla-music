#import "Score.h"

@implementation Score

- (NSString *)firstLetterOfTitle {
    [self willAccessValueForKey:@"firstLetterOfTitle"];
    NSString *aString = [[self title] uppercaseString];
    NSString *stringToReturn = [aString substringWithRange:[aString rangeOfComposedCharacterSequenceAtIndex:0]];
    [self didAccessValueForKey:@"firstLetterOfTitle"];
    return stringToReturn;
}

- (NSURL *)thumbnailURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://nla.gov.au/%@-t", [self identifier]]];
}

- (NSURL *)coverURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://nla.gov.au/%@-e", [self identifier]]];
}

@end
