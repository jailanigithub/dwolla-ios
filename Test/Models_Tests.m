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



@interface Models_Tests : GHTestCase {}
@property (retain) DwollaAPI *dwollaAPI;
@property (retain) id mockTokenRepository;
@property (retain) id mockHttpRequestRepository;
@end

@implementation Models_Tests

@synthesize dwollaAPI, mockTokenRepository, mockHttpRequestRepository;

- (void)setUp
{
    [super setUp];
    self.dwollaAPI = [DwollaAPI sharedInstance];
    self.mockTokenRepository = [OCMockObject mockForClass:[OAuthTokenRepository class]];
    self.mockHttpRequestRepository = [OCMockObject mockForClass:[HttpRequestRepository class]];
    
    [dwollaAPI setOAuthTokenRepository:self.mockTokenRepository];
    [dwollaAPI setHttpRequestRepository:self.mockHttpRequestRepository];
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
    [[[self.mockHttpRequestRepository stub] andReturn:result] postRequest:OCMOCK_ANY withBody:OCMOCK_ANY];
}

- (void) Setup_GetRequest_WithDictionary: (NSDictionary *) result {
    [[[self.mockHttpRequestRepository stub] andReturn:result] getRequest:OCMOCK_ANY];
}

- (void) Setup_GetRequest_WithContactsDictionary {
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSArray alloc] initWithObjects:
                             [[NSDictionary alloc] initWithObjectsAndKeys:@"Ben Facebook Test", @"Name", @"12345", @"Id", @"Facebook", @"Type", @"", @"Image", @"Des Moines", @"City", @"IA", @"State", nil],
                             [[NSDictionary alloc] initWithObjectsAndKeys:@"Ben Dwolla Test", @"Name", @"812-111-111", @"Id", @"Dwolla", @"Type", @"", @"Image", @"Des Moines", @"City", @"IA", @"State", nil], nil], @"Response", nil];
    [self Setup_GetRequest_WithDictionary:result];
}

- (void) Setup_GetRequest_WithTransactionDictionary {
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSArray alloc]initWithObjects:[self GetTransactionDictionary], nil], @"Response", nil];
    [self Setup_GetRequest_WithDictionary:result];
}

- (NSDictionary *) GetTransactionDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
    @"1.91", @"Amount",
    @"7/18/2012 1:45:36 PM", @"Date",
    @"money_sent", @"Type",
    @"Dwolla", @"UserType",
    @"812-737-5434", @"DestinationId",
    @"Timbuktuu Coffee", @"DestinationName",
    @"", @"SourceId",
    @"", @"SourceName",
    @"", @"ClearingDate",
    @"From iPhone", @"Notes",
    @"1226108", @"Id",
    @"processed", @"Status",
    nil];
}

- (DwollaContacts *)Get_Mocked_DwollaContacts
{
    DwollaContact* one = [[DwollaContact alloc] initWithUserID:@"12345" name:@"Ben Facebook Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Facebook" address:@"" longitude:@"" latitude:@""];
    
    DwollaContact* two = [[DwollaContact alloc] initWithUserID:@"812-111-111" name:@"Ben Dwolla Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Dwolla" address:@"" longitude:@"" latitude:@""];
    
    return [[DwollaContacts alloc] initWithSuccess:YES contacts:[[NSMutableArray alloc] initWithObjects:one, two, nil]];
}


-(void)testSend_WithSuccessfulResponse_ShouldReturnValidTransactionId
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"12345", @"Response",  nil];
    [self Setup_PostRequest_WithDictionary:result];
    
    
    NSString* response = [dwollaAPI sendMoneyWithPIN:@"5211" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"0.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""];
    GHAssertTrue([response isEqualToString:@"12345"],@"INCORRECT ID");
}
-(void)testRequest_WithSuccessfulResponse_ShouldReturnValidRequestId
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"12345", @"Response", nil];
    [self Setup_PostRequest_WithDictionary:result];
    
    NSString* response = [dwollaAPI requestMoneyWithPIN:@"5211" sourceID:@"812-111-1111" sourceType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" notes:@""];
    GHAssertTrue([response isEqualToString:@"12345"],@"INCORRECT ID");
}

-(void)testGetBalance_WithSuccessfulResponse_ShouldReturnValidBalance
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"55.76", @"Response", nil];
    [self Setup_GetRequest_WithDictionary:result];
    
    NSString* response = [dwollaAPI getBalance];
    
    GHAssertTrue([response isEqualToString:@"55.76"],@"INCORRECT AMOUNT");
}


-(void)testGetContacts_WithSuccessfulResponse_ShouldReturnValidContacts
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [self Setup_GetRequest_WithContactsDictionary];
    
    DwollaContacts* contacts = [dwollaAPI getContactsByName:@"" types:@"" limit:@""];
    DwollaContacts *contacts2 = [self Get_Mocked_DwollaContacts];
    
    GHAssertTrue([contacts isEqualTo:contacts2],@"NOT EQUAL!");
}

-(void)testGetNearby_WithSuccessfulResponse_ShouldReturnValidContacts
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [self Setup_GetRequest_WithContactsDictionary];

    DwollaContacts* contacts = [dwollaAPI getNearbyWithLatitude:@"10.00" Longitude:@"10.00" Limit:@"" Range:@""];
    DwollaContacts *contacts2 = [self Get_Mocked_DwollaContacts];
    
    GHAssertTrue([contacts isEqualTo:contacts2],@"NOT EQUAL!");
}

-(void)testGetFundingSources_WithSuccessfulResponse_ShouldReturnValidFundingSources
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                              @"TVmMwlKz1z6HmOK1np8NFA==", @"Id",
                                                              @"Donations Collection Fund - Savings", @"Name",
                                                              @"Savings", @"Type",
                                                              @"true", @"Verified",
                                                              nil], nil], @"Response", nil];

    [self Setup_GetRequest_WithDictionary:result];
    
    DwollaFundingSources* sources = [dwollaAPI getFundingSources];
    
    DwollaFundingSource* one = [[DwollaFundingSource alloc] initWithSourceID:@"TVmMwlKz1z6HmOK1np8NFA==" name:@"Donations Collection Fund - Savings" type:@"Savings" verified:@"true"];
    
    DwollaFundingSources* sources2 = [[DwollaFundingSources alloc] initWithSuccess:YES sources:[[NSMutableArray alloc] initWithObjects:one, nil]];
    
    GHAssertTrue([sources isEqualTo:sources2],@"NOT EQUAL!");

}

-(void)testGetFundingSource_WithValidFundingSource_ShouldReturnValidFundingSource
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                              @"TVmMwlKz1z6HmOK1np8NFA==", @"Id",
                                                              @"Donations Collection Fund - Savings", @"Name",
                                                              @"Savings", @"Type",
                                                              @"true", @"Verified",
                                                              nil], nil], @"Response", nil];
    
    [self Setup_GetRequest_WithDictionary: result];
    
    DwollaFundingSource* source = [dwollaAPI getFundingSource:@"123"];
    
    DwollaFundingSource* one = [[DwollaFundingSource alloc] initWithSourceID:@"TVmMwlKz1z6HmOK1np8NFA==" name:@"Donations Collection Fund - Savings" type:@"Savings" verified:@"true"];
    
    
    GHAssertTrue([source isEqualTo:one],@"NOT EQUAL!");
}

-(void)testGetAccountInfo_WithSuccessfulResponse_ShouldReturnValidAccountInformation
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSDictionary alloc] initWithObjectsAndKeys:
                                                              @"Ames", @"City",
                                                              @"IA", @"State",
                                                              @"Personal", @"Type",
                                                              @"812-570-5285", @"Id",
                                                              @"Nick Schulze", @"Name",
                                                              @"0", @"Latitude",
                                                              @"0", @"Longitude",
                                                              nil], @"Response", nil];
    [self Setup_GetRequest_WithDictionary:result];    
    
    DwollaUser* user = [dwollaAPI getAccountInfo];
    
    DwollaUser* user2 = [[DwollaUser alloc] initWithUserID:@"812-570-5285" name:@"Nick Schulze" city:@"Ames" state:@"IA" latitude:@"41.584546" longitude:@"-93.634167" type:@"Personal"];
    
    GHAssertTrue([user isEqualTo:user2], @"NOT EQUAL");
}

-(void)testGetTransactions_WithSuccessfulResponse_ShouldReturnValidTransactions
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [self Setup_GetRequest_WithTransactionDictionary];
    
    DwollaTransactions* transactions = [dwollaAPI getTransactionsSince:@"" limit:@"" skip:@""];
    
    DwollaTransaction* transaction = [[DwollaTransaction alloc] initWithAmount:@"1.91" clearingDate:@"" date:@"7/18/2012 1:45:36 PM" destinationID:@"812-737-5434" destinationName:@"Timbuktuu Coffee" transactionID:@"1226108" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    DwollaTransactions* transactions2 = [[DwollaTransactions alloc] initWithSuccess:YES transactions:[[NSMutableArray alloc] initWithObjects:transaction, nil]];
    
    GHAssertTrue([transactions isEqualTo:transactions2],@"NOT EQUAL");
}

-(void)testGetTransaction_WithSuccessfulResponse_ShouldReturnValidTransaction
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [self Setup_GetRequest_WithDictionary:[self GetTransactionDictionary]];

    DwollaTransaction* transaction = [dwollaAPI getTransaction:@""];
    
    DwollaTransaction* transaction2 = [[DwollaTransaction alloc] initWithAmount:@"1.91" clearingDate:@"" date:@"7/18/2012 1:45:36 PM" destinationID:@"812-737-5434" destinationName:@"Timbuktuu Coffee" transactionID:@"1226108" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    GHAssertTrue([transaction isEqualTo:transaction2], @"NOT EQUAL");
}

-(void)testGetTransactionStats_WithSuccessfulResponse_ShouldReturnValidTransactionStats
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"1", @"TransactionsCount",
                             @"0.3", @"TransactionsTotal",
                             nil], @"Response", nil];
    
    [self Setup_GetRequest_WithDictionary:result];
    
    DwollaTransactionStats* stats = [dwollaAPI getTransactionStats:@"" end:@""];
    
    DwollaTransactionStats* stats2 = [[DwollaTransactionStats alloc] initWithSuccess:YES count:@"1" total:@"0.3"];
    
    GHAssertTrue([stats isEqualTo:stats2], @"NOT EQUAL");
}


@end
