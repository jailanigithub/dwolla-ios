//
//  HttpRequestHelper_Tests.m
//  DwollaOAuth
//
//  Created by James Armstead on 12/19/12.
//
//

#import "HttpRequestHelper.h"
#import <GHUnitIOS/GHUnit.h>

@interface HttpRequestHelper_Tests : GHTestCase {}
@property (retain) HttpRequestHelper *httpRequestHelper;
@end

@implementation HttpRequestHelper_Tests


- (void)setUp
{
    [super setUp];
    self.httpRequestHelper = [[HttpRequestHelper alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}


-(void)testSend_WithNoAccessToken_ShouldThrowException
{
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"1111", @"pin",
                                                @"812-111-1111", @"destinationId",
                                                @"1.00", @"amount", nil];
    
    NSData* theData = [self.httpRequestHelper getJSONDataFromNsDictionary: parameterDictionary];
    
    NSString* jsonString = [[NSString alloc] initWithData:theData
                                             encoding:NSUTF8StringEncoding];
    
    GHAssertTrue([jsonString isEqualToString: @"{\"pin\":\"1111\",\"destinationId\":\"812-111-1111\",\"amount\":\"1.00\"}"], @"JSON data does not match");
}

@end
