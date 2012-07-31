//
//  DwollaOAuthTests.m
//  DwollaOAuthTests
//
//  Created by Nick Schulze on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaOAuthTests.h"

@implementation DwollaOAuthTests

- (void)setUp
{
    [super setUp];
    [DwollaAPI isTest];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


-(void)testSendMoney
{
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"12345", @"Response",  nil];
    [DwollaAPI setTestResult:result];
    
    NSString* response = [DwollaAPI sendMoneyWithPIN:@"" destinationID:@"" destinationType:@""
                         amount:@"" facilitatorAmount:@""
                 assumeCosts:@"" notes:@"" fundingSourceID:@""];
    STAssertTrue([response isEqualToString:@"12345"],@"INCORRECT ID");
}

-(void)testRequestMoney
{
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"12345", @"Response", nil];
    [DwollaAPI setTestResult:result];
    
    NSString* response = [DwollaAPI requestMoneyWithPIN:@"" sourceID:@"" sourceType:@""
                            amount:@"" facilitatorAmount:@"" notes:@""];
    STAssertTrue([response isEqualToString:@"12345"],@"INCORRECT ID");
}

-(void)testGetBalance
{
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"55.76", @"Response", nil];
    [DwollaAPI setTestResult:result];
    
    NSString* response = [DwollaAPI getBalance];
    
    STAssertTrue([response isEqualToString:@"55.76"],@"INCORRECT AMOUNT");
}

-(void)testGetContacts
{
    NSString* response = [NSString stringWithFormat:@"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Name\":\"Ben Facebook Test\",\"Id\":\"12345\",\"Type\":\"Facebook\",\"Image\":\"\",\"City\":\"Des Moines\",\"State\":\"IA\"},{\"Name\":\"Ben Dwolla Test\",\"Id\":\"812-111-111\",\"Type\":\"Dwolla\",\"Image\":\"\",\"City\":\"Des Moines\",\"State\":\"IA\"}]}"]; 
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];
    
    [DwollaAPI setTestResult:result];
    DwollaContacts* contacts = [DwollaAPI getContactsByName:@"" types:@"" limit:@""];
    
    DwollaContact* one = [[DwollaContact alloc] initWithUserID:@"12345" name:@"Ben Facebook Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Facebook"];
    
     DwollaContact* two = [[DwollaContact alloc] initWithUserID:@"812-111-111" name:@"Ben Dwolla Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Dwolla"];
    
    DwollaContacts* contacts2 = [[DwollaContacts alloc] initWithSuccess:YES contacts:[[NSMutableArray alloc] initWithObjects:one, two, nil]];
    
    STAssertTrue([contacts isEqualTo:contacts2],@"NOT EQUAL!");
}

-(void)testGetNearby
{
   NSString* response = [NSString stringWithFormat:@"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Name\":\"Ben Facebook Test\",\"Id\":\"12345\",\"Type\":\"Facebook\",\"Image\":\"\",\"City\":\"Des Moines\",\"State\":\"IA\"},{\"Name\":\"Ben Dwolla Test\",\"Id\":\"812-111-111\",\"Type\":\"Dwolla\",\"Image\":\"\",\"City\":\"Des Moines\",\"State\":\"IA\"}]}"];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];
    [DwollaAPI setTestResult:result];
    DwollaContacts* contacts = [DwollaAPI getNearbyWithLatitude:@"" Longitude:@"" Limit:@"" Range:@""];
    
    DwollaContact* one = [[DwollaContact alloc] initWithUserID:@"12345" name:@"Ben Facebook Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Facebook"];
    
    DwollaContact* two = [[DwollaContact alloc] initWithUserID:@"812-111-111" name:@"Ben Dwolla Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Dwolla"];
    
    DwollaContacts* contacts2 = [[DwollaContacts alloc] initWithSuccess:YES contacts:[[NSMutableArray alloc] initWithObjects:one, two, nil]];
    
    STAssertTrue([contacts isEqualTo:contacts2],@"NOT EQUAL!");
}

-(void)testGetSources
{
    NSString* response = [NSString stringWithFormat:@"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Id\":\"TVmMwlKz1z6HmOK1np8NFA==\",\"Name\":\"Donations Collection Fund - Savings\",\"Type\":\"Savings\",\"Verified\":\"true\"},{\"Id\":\"TqmKw8Kz1z6HmOK1np8Npq==,\"Name\":\"Donations Payout Account - Checking\",\"Type\":\"Checking\",\"Verified\":\"true\"}]}"];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];

    [DwollaAPI setTestResult:result];

    DwollaFundingSources* sources = [DwollaAPI getFundingSources];
    
    DwollaFundingSource* one = [[DwollaFundingSource alloc] initWithSourceID:@"TVmMwlKz1z6HmOK1np8NFA==" name:@"Donations Collection Fund - Savings" type:@"Savings" verified:@"true"];
    
    DwollaFundingSource* two = [[DwollaFundingSource alloc] initWithSourceID:@"TqmKw8Kz1z6HmOK1np8Npq==" name:@"Donations Payout Account - Checking" type:@"Checking" verified:@"true"];
    
    DwollaFundingSources* sources2 = [[DwollaFundingSources alloc] initWithSuccess:YES sources:[[NSMutableArray alloc] initWithObjects:one, two, nil]];
    
    //STAssertTrue([sources isEqualTo:sources2],@"NOT EQUAL!");

}

-(void)testGetSource
{
    NSString* response = [NSString stringWithFormat:@"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Id\":\"TVmMwlKz1z6HmOK1np8NFA==\",\"Name\":\"Donations Collection Fund - Savings\",\"Type\":\"Savings\",\"Verified\":\"true\"}]}"];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];
    
    [DwollaAPI setTestResult:result];

    
    DwollaFundingSource* source =  [DwollaAPI getFundingSource:@""];
    
    DwollaFundingSource* one = [[DwollaFundingSource alloc] initWithSourceID:@"TVmMwlKz1z6HmOK1np8NFA==" name:@"Donations Collection Fund - Savings" type:@"Savings" verified:@"true"];
    
    STAssertTrue([source isEqualTo:one],@"NOT EQUAL!");

}

-(void)testGetInfo
{
    NSString* response = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"City\":\"Ames\",\"State\":\"IA\",\"Type\":\"Personal\",\"Id\":\"812-570-5285\",\"Name\":\"Nick Schulze\",\"Latitude\":0,\"Longitude\":0}}";
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];
    
    [DwollaAPI setTestResult:result];
    
    DwollaUser* user = [DwollaAPI getAccountInfo];
    
    DwollaUser* user2 = [[DwollaUser alloc] initWithUserID:@"812-570-5285" name:@"Nick Schulze" city:@"Ames" state:@"IA" latitude:@"41.584546" longitude:@"-93.634167" type:@"Personal"];
    
    STAssertTrue([user isEqualTo:user2], @"NOT EQUAL");
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
    
    [DwollaAPI setTestResult:result];
    
    DwollaTransactions* transactions = [DwollaAPI getTransactionsSince:@"" limit:@"" skip:@""];
    
    DwollaTransaction* transaction = [[DwollaTransaction alloc] initWithAmount:@"1.91" clearingDate:@"" date:@"7/18/2012 1:45:36 PM" destinationID:@"812-737-5434" destinationName:@"Timbuktuu Coffee" transactionID:@"1226108" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    DwollaTransactions* transactions2 = [[DwollaTransactions alloc] initWithSuccess:YES transactions:[[NSMutableArray alloc] initWithObjects:transaction, nil]];
    
    STAssertTrue([transactions isEqualTo:transactions2],@"NOT EQUAL");
}

-(void)testGetTransaction
{
    NSString* response = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Amount\":1.92,\"Date\":\"7/18/2012 1:45:36 PM\",\"Type\":\"money_sent\",\"UserType\":\"Dwolla\",\"DestinationId\":\"812-737-5434\",\"DestinationName\":\"Timbuktuu Coffee\",\"SourceId\":\"\",\"SourceName\":\"\",\"ClearingDate\":\"\",\"Notes\":\"From iPhone\",\"Id\":1226108,\"Status\":\"processed\"}]}";
                                                    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
                                                    
    NSDictionary *result = [parser objectWithString:response];
    
    [DwollaAPI setTestResult:result];

   // DwollaTransaction* transaction = [DwollaAPI getTransaction:@""];
    
    DwollaTransaction* transaction2 = [[DwollaTransaction alloc] initWithAmount:@"1.92" clearingDate:@"" date:@"7/18/2012 1:45:36 PM" destinationID:@"812-737-5434" destinationName:@"Timbuktuu Coffee" transactionID:@"1226108" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
   // STAssertTrue([transaction isEqualTo:transaction2], @"NOT EQUAL");
}

-(void)testGetTransactionStats
{    
    NSString* response = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"TransactionsCount\":1,\"TransactionsTotal\":0.30000}}";
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *result = [parser objectWithString:response];
    
    [DwollaAPI setTestResult:result];
    
    DwollaTransactionStats* stats = [DwollaAPI getTransactionStats:@"" end:@""];
    
    
    DwollaTransactionStats* stats2 = [[DwollaTransactionStats alloc] initWithSuccess:YES count:@"1" total:@"0.3"];
    
    STAssertTrue([stats isEqualTo:stats2], @"NOT EQUAL");
    
}


@end
