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



@interface DwollaOAuthTests : GHTestCase {}
@property (retain) DwollaAPI *dwollaAPI;
@property (retain) id mockNSUserDefaults;
@end

@implementation DwollaOAuthTests

@synthesize dwollaAPI, mockNSUserDefaults;

- (void)setUp
{
    [super setUp];
    dwollaAPI = [DwollaAPI sharedInstance];
    mockNSUserDefaults = [OCMockObject mockForClass:[NSUserDefaults class]];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void) setup_AccessToken_true {
    [[[self.mockNSUserDefaults stub] andReturn:@"123456789"] objectForKey:@"token"];
    [[[self.mockNSUserDefaults stub] andReturn:[NSUserDefaults alloc]] standardUserDefaults];
}

-(void) Send_WithNoAccessToken_ThrowError
{
    GHAssertNoThrow([dwollaAPI sendMoneyWithPIN:@"" destinationID:@"" destinationType:@""
                                         amount:@"" facilitatorAmount:@""
                                    assumeCosts:@"" notes:@"" fundingSourceID:@""], @"Send didn't throw an error with no access token");
}

-(void)testSendMoney
{
    [self setup_AccessToken_true];
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"12345", @"Response",  nil];

    
    NSString* response = [dwollaAPI sendMoneyWithPIN:@"" destinationID:@"" destinationType:@""
                         amount:@"" facilitatorAmount:@""
                 assumeCosts:@"" notes:@"" fundingSourceID:@""];
    GHAssertTrue([response isEqualToString:@"12345"],@"INCORRECT ID");
}
-(void)testRequestMoney
{
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"12345", @"Response", nil];

    
    NSString* response = [dwollaAPI requestMoneyWithPIN:@"" sourceID:@"" sourceType:@""
                            amount:@"" facilitatorAmount:@"" notes:@""];
    GHAssertTrue([response isEqualToString:@"12345"],@"INCORRECT ID");
}

-(void)testGetBalance
{
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"55.76", @"Response", nil];

    
    NSString* response = [dwollaAPI getBalance];
    
    GHAssertTrue([response isEqualToString:@"55.76"],@"INCORRECT AMOUNT");
}

-(void)testGetContacts
{
    NSString* response = [NSString stringWithFormat:@"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Name\":\"Ben Facebook Test\",\"Id\":\"12345\",\"Type\":\"Facebook\",\"Image\":\"\",\"City\":\"Des Moines\",\"State\":\"IA\"},{\"Name\":\"Ben Dwolla Test\",\"Id\":\"812-111-111\",\"Type\":\"Dwolla\",\"Image\":\"\",\"City\":\"Des Moines\",\"State\":\"IA\"}]}"]; 
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];
    

    DwollaContacts* contacts = [dwollaAPI getContactsByName:@"" types:@"" limit:@""];
    
    DwollaContact* one = [[DwollaContact alloc] initWithUserID:@"12345" name:@"Ben Facebook Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Facebook" address:@"" longitude:@"" latitude:@""];
    
     DwollaContact* two = [[DwollaContact alloc] initWithUserID:@"812-111-111" name:@"Ben Dwolla Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Dwolla" address:@"" longitude:@"" latitude:@""];
    
    DwollaContacts* contacts2 = [[DwollaContacts alloc] initWithSuccess:YES contacts:[[NSMutableArray alloc] initWithObjects:one, two, nil]];
    
    GHAssertTrue([contacts isEqualTo:contacts2],@"NOT EQUAL!");
}

-(void)testGetNearby
{
   NSString* response = [NSString stringWithFormat:@"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Name\":\"Ben Facebook Test\",\"City\":\"Des Moines\",\"Id\":\"12345\",\"Type\":\"Facebook\",\"Image\":\"\",\"State\":\"IA\"},{\"Name\":\"Ben Dwolla Test\",\"Id\":\"812-111-111\",\"Type\":\"Dwolla\",\"Image\":\"\",\"City\":\"Des Moines\",\"State\":\"IA\"}]}"];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];

    DwollaContacts* contacts = [dwollaAPI getNearbyWithLatitude:@"" Longitude:@"" Limit:@"" Range:@""];
    
    DwollaContact* one = [[DwollaContact alloc] initWithUserID:@"12345" name:@"Ben Facebook Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Facebook" address:@"" longitude:@"" latitude:@""];
    
    DwollaContact* two = [[DwollaContact alloc] initWithUserID:@"812-111-111" name:@"Ben Dwolla Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Dwolla" address:@"" longitude:@"" latitude:@""];
    
    DwollaContacts* contacts2 = [[DwollaContacts alloc] initWithSuccess:YES contacts:[[NSMutableArray alloc] initWithObjects:one, two, nil]];
    
    GHAssertTrue([contacts isEqualTo:contacts2],@"NOT EQUAL!");
}

-(void)testGetSources
{
    NSString* response = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Id\":\"TVmMwlKz1z6HmOK1np8NFA==\",\"Name\":\"Donations Collection Fund - Savings\",\"Type\":\"Savings\",\"Verified\":\"true\"}]}";
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];



    DwollaFundingSources* sources = [dwollaAPI getFundingSources];
    
    DwollaFundingSource* one = [[DwollaFundingSource alloc] initWithSourceID:@"TVmMwlKz1z6HmOK1np8NFA==" name:@"Donations Collection Fund - Savings" type:@"Savings" verified:@"true"];
    
    DwollaFundingSources* sources2 = [[DwollaFundingSources alloc] initWithSuccess:YES sources:[[NSMutableArray alloc] initWithObjects:one, nil]];
    
    GHAssertTrue([sources isEqualTo:sources2],@"NOT EQUAL!");

}

-(void)testGetSource
{
    NSString* response = [NSString stringWithFormat:@"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Id\":\"TVmMwlKz1z6HmOK1np8NFA==\",\"Name\":\"Donations Collection Fund - Savings\",\"Type\":\"Savings\",\"Verified\":\"true\"}]}"];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];
    


    
    DwollaFundingSource* source =  [dwollaAPI getFundingSource:@""];
    
    DwollaFundingSource* one = [[DwollaFundingSource alloc] initWithSourceID:@"TVmMwlKz1z6HmOK1np8NFA==" name:@"Donations Collection Fund - Savings" type:@"Savings" verified:@"true"];
    
    GHAssertTrue([source isEqualTo:one],@"NOT EQUAL!");

}

-(void)testGetInfo
{
    NSString* response = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"City\":\"Ames\",\"State\":\"IA\",\"Type\":\"Personal\",\"Id\":\"812-570-5285\",\"Name\":\"Nick Schulze\",\"Latitude\":0,\"Longitude\":0}}";
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];
    

    
    DwollaUser* user = [dwollaAPI getAccountInfo];
    
    DwollaUser* user2 = [[DwollaUser alloc] initWithUserID:@"812-570-5285" name:@"Nick Schulze" city:@"Ames" state:@"IA" latitude:@"41.584546" longitude:@"-93.634167" type:@"Personal"];
    
    GHAssertTrue([user isEqualTo:user2], @"NOT EQUAL");
}

//-(void)testRegisterUser
//{
//    [DwollaAPI registerUserWithEmail:@"" password:@"" pin:@"" firstName:@""
//                            lastName:@"" address:@"" address2:@"" city:@""
//                               state:@"" zip:@"" phone:@"" birthDate:@""
//                                type:@"" organization:@"" ein:@"" acceptTerms:YES];
//}

-(void)testGetTransactions
{
    NSString* response = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Amount\":1.91,\"Date\":\"7/18/2012 1:45:36 PM\",\"Type\":\"money_sent\",\"UserType\":\"Dwolla\",\"DestinationId\":\"812-737-5434\",\"DestinationName\":\"Timbuktuu Coffee\",\"SourceId\":\"\",\"SourceName\":\"\",\"ClearingDate\":\"\",\"Notes\":\"From iPhone\",\"Id\":1226108,\"Status\":\"processed\"}]}";
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];
    

    
    DwollaTransactions* transactions = [dwollaAPI getTransactionsSince:@"" limit:@"" skip:@""];
    
    DwollaTransaction* transaction = [[DwollaTransaction alloc] initWithAmount:@"1.91" clearingDate:@"" date:@"7/18/2012 1:45:36 PM" destinationID:@"812-737-5434" destinationName:@"Timbuktuu Coffee" transactionID:@"1226108" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    DwollaTransactions* transactions2 = [[DwollaTransactions alloc] initWithSuccess:YES transactions:[[NSMutableArray alloc] initWithObjects:transaction, nil]];
    
    GHAssertTrue([transactions isEqualTo:transactions2],@"NOT EQUAL");
}

-(void)testGetTransaction
{
    NSString* response = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"Amount\":1.92,\"Date\":\"7/18/2012 1:45:36 PM\",\"Type\":\"money_sent\",\"UserType\":\"Dwolla\",\"DestinationId\":\"812-737-5434\",\"DestinationName\":\"Timbuktuu Coffee\",\"SourceId\":\"\",\"SourceName\":\"\",\"ClearingDate\":\"\",\"Notes\":\"From iPhone\",\"Id\":1226108,\"Status\":\"processed\"}}";
                                                    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
                                                    
    NSDictionary *result = [parser objectWithString:response];
    


    DwollaTransaction* transaction = [dwollaAPI getTransaction:@""];
    
    DwollaTransaction* transaction2 = [[DwollaTransaction alloc] initWithAmount:@"1.92" clearingDate:@"" date:@"7/18/2012 1:45:36 PM" destinationID:@"812-737-5434" destinationName:@"Timbuktuu Coffee" transactionID:@"1226108" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    GHAssertTrue([transaction isEqualTo:transaction2], @"NOT EQUAL");
}

-(void)testGetTransactionStats
{    
    NSString* response = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"TransactionsCount\":1,\"TransactionsTotal\":0.30000}}";
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];
    

    
    DwollaTransactionStats* stats = [dwollaAPI getTransactionStats:@"" end:@""];
    
    
    DwollaTransactionStats* stats2 = [[DwollaTransactionStats alloc] initWithSuccess:YES count:@"1" total:@"0.3"];
    
    GHAssertTrue([stats isEqualTo:stats2], @"NOT EQUAL");
    
}


@end
