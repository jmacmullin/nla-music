//
//  NLAOpenArchiveController.m
//  nla-music
//
//  Copyright © 2012 Jake MacMullin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "NLAOpenArchiveController.h"
#import "AFNetworking.h"

@interface NLAOpenArchiveController()

@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic, strong) NSMutableString *characters;
@property (nonatomic, strong) NLAItemInformation *itemInformation;

@end


@implementation NLAOpenArchiveController

+ (NLAOpenArchiveController *)sharedController
{
    static NLAOpenArchiveController *sharedInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)requestDetailsForItemWithIdentifier:(NSString *)itemIdentifier success:(SuccessBlock)successBlock
{
    [self setSuccessBlock:successBlock];
    
    if (self.queue==nil) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [self setQueue:queue];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.nla.gov.au/apps/oaicat/servlet/OAIHandler?verb=GetRecord&metadataPrefix=oai_dc&identifier=oai:nla.gov.au:%@", itemIdentifier];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFXMLRequestOperation *requestOperation;
    requestOperation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request
                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
                                                                               
                                                                               NLAItemInformation *itemInfo = [[NLAItemInformation alloc] init];
                                                                               [self setItemInformation:itemInfo];
                                                                               
                                                                               [XMLParser setDelegate:self];
                                                                               [XMLParser parse];
                                                                               
                                                                           }
                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParse) {
                                                                               // call the callback
                                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                                   self.successBlock(nil);
                                                                               });
                                                                           }];
    [self.queue addOperation:requestOperation];
}


#pragma mark - XML Parser Delegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [self setCharacters:[NSMutableString string]];
    
    if ([elementName isEqualToString:@"dc:title"] || [elementName isEqualToString:@"dc:creator"] || [elementName isEqualToString:@"dc:description"]) {
        [self setCurrentElement:elementName];
    } else {
        [self setCurrentElement:nil];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentElement!=nil) {
        [self.characters appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"dc:title"]) {
        [self.itemInformation setTitle:self.characters];
    } else if ([elementName isEqualToString:@"dc:creator"]) {
        [self.itemInformation setCreator:self.characters];
    } else if ([elementName isEqualToString:@"dc:description"]) {
        [self.itemInformation setDescription:self.characters];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // call the callback
    dispatch_async(dispatch_get_main_queue(), ^{
        self.successBlock(self.itemInformation);
    });
}

@end
