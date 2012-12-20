//
//  DwollaOAuthTests.m
//  DwollaOAuthTests
//
//  Created by Nick Schulze on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h>
#import <DwollaOAuthLib/DwollaAPI.h>

@interface DwollaAPI_Tests : GHTestCase {}
@property (retain) DwollaAPI *dwollaAPI;
@property (retain) id mockTokenRepository;
@property (retain) id mockHttpRequestRepository;
@property (retain) id mockHttpRequestHelper;
@property (retain) id mockNSURLConnectionRepository;
@end

@implementation DwollaAPI_Tests

@synthesize dwollaAPI, mockTokenRepository, mockHttpRequestRepository, mockHttpRequestHelper;

- (void)setUp
{
    [super setUp];
    self.dwollaAPI = [DwollaAPI sharedInstance];
    self.mockTokenRepository = [OCMockObject mockForClass:[OAuthTokenRepository class]];
    self.mockHttpRequestRepository = [OCMockObject mockForClass:[HttpRequestRepository class]];
    self.mockHttpRequestHelper = [OCMockObject mockForClass:[HttpRequestHelper class]];
    self.mockNSURLConnectionRepository = [OCMockObject mockForClass:[NSURLConnectionRepository class]];
    
    [dwollaAPI setOAuthTokenRepository:self.mockTokenRepository];
    [dwollaAPI setHttpRequestRepository:self.mockHttpRequestRepository];
    [dwollaAPI setHttpRequestHelper:self.mockHttpRequestHelper];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void) Setup_WithAccessToken_ClientKey_ClientSecret {
    BOOL boolYes = YES;
    [[[self.mockTokenRepository stub] andReturnValue:OCMOCK_VALUE(boolYes)] hasAccessToken];
    [[[self.mockTokenRepository stub] andReturn:@"123456789"] getAccessToken];
    [[[self.mockTokenRepository stub] andReturn:@"123"] getClientKey];
    [[[self.mockTokenRepository stub] andReturn:@"456"] getClientSecret];
}

- (void) Setup_PostRequest_WithDictionary: (NSDictionary *) result {
    [[[self.mockHttpRequestRepository stub] andReturn:result] postRequest:OCMOCK_ANY withParameterDictionary:OCMOCK_ANY];
}

- (void) Setup_GetRequest_WithDictionary: (NSDictionary *) result {
    [[[self.mockHttpRequestRepository stub] andReturn:result] getRequest:OCMOCK_ANY];
}

-(void) Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:(NSDictionary*) responseDictionary
{
    [[[self.mockNSURLConnectionRepository stub] andReturn:responseDictionary] sendSynchronousRequest:OCMOCK_ANY];
    
    //Mocked out NSURLConnection and passed it to a real HttpRequestRepository to test Logic
    HttpRequestRepository *httpRequestRepository = [[HttpRequestRepository alloc] init];
    [httpRequestRepository setNsURLConnectionRepository:self.mockNSURLConnectionRepository];
    [dwollaAPI setHttpRequestRepository:httpRequestRepository];
}


-(void)testSend_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"0.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""], @"No Exception was through when no AccessToken was passed in");
}

-(void)testSend_WithNoPIN_ShouldThrowException
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    GHAssertThrows([dwollaAPI sendMoneyWithPIN:@"" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"0.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""], @"No Exception was through when no PIN was passed in");
}
-(void)testSend_WithNoDestintation_ShouldThrowException
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    GHAssertThrows([dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"" destinationType:@"dwolla" amount:@"0.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""], @"No Exception was through when no Destination was passed in");
}
-(void)testSend_WithNoAmount_ShouldThrowException
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    GHAssertThrows([dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""], @"No Exception was through when no Amount was passed in");
}

-(void)testSend_WithValidData_ShouldCallHttpRequestRepositoryWithSendURLAndNSData
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [[[self.mockHttpRequestHelper stub] andReturn:[NSData alloc]]getJSONDataFromNsDictionary: OCMOCK_ANY];
    
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"1111", @"pin",
                                                @"812-111-1111", @"destinationId",
                                                @"1.00", @"amount",
                                                @"dwolla", @"destinationType", nil];
    
    [[self.mockHttpRequestRepository expect] postRequest:@"https://www.dwolla.com/oauth/rest/transactions/send?oauth_token=123456789" withParameterDictionary:parameterDictionary];
    
    [dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testSend_WithInValidData_ShouldThrowAnErrorIfSuccessComesBackFalse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [[[self.mockHttpRequestHelper stub] andReturn:[NSData alloc]]getJSONDataFromNsDictionary: OCMOCK_ANY];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"false", @"Success",
                                               @"asdf", @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary];
    
     GHAssertThrows([dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""], @"No Exception was through when Response came back with Success is false");
}

-(void)testSend_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [[[self.mockHttpRequestHelper stub] andReturn:[NSData alloc]]getJSONDataFromNsDictionary: OCMOCK_ANY];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               @"1010101", @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary];
    
    NSString *result = [dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""];
    
    GHAssertTrue([@"1010101" isEqualToString:result], @"Response is not coming back as the Transaction ID");
    
}

//REQUEST MONEY//
-(void)testRequest_WithValidData_ShouldCallHttpRequestRepositoryWithSendURLAndNSData
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [[[self.mockHttpRequestHelper stub] andReturn:[NSData alloc]]getJSONDataFromNsDictionary: OCMOCK_ANY];
    
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"1111", @"pin",
                                                @"812-111-1111", @"sourceId",
                                                @"1.00", @"amount",
                                                @"dwolla", @"sourceType", nil];
    
    [[self.mockHttpRequestRepository expect] postRequest:@"https://www.dwolla.com/oauth/rest/transactions/request?oauth_token=123456789" withParameterDictionary:parameterDictionary];
    
    [dwollaAPI requestMoneyWithPIN:@"1111" sourceID:@"812-111-1111" sourceType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" notes:@""];
    
    [self.mockHttpRequestRepository verify];
}



@end
