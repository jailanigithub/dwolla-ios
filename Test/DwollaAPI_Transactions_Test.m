//
//  Created by James Armstead on 12/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h>
#import <DwollaOAuthLib/DwollaAPI.h>
#import "DwollaAPI_Base_Test.h"

@interface DwollaAPI_Transactions_Test : DwollaAPI_Base_Test {}
@end

@implementation DwollaAPI_Transactions_Test

-(void)testGetTransactionsSince_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getTransactionsSince:@"" withType:@"" withLimit:@"" withSkip:@""], @"No Exception was through when no AccessToken was passed in");
}

-(void)testGetTransactionsSince_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"123456789", @"oauth_token",
                                         @"10", @"limit", nil];
    
    [[self.mockHttpRequestRepository expect] getRequest: @"https://www.dwolla.com/oauth/rest/transactions"
                           withQueryParameterDictionary: parameterDictionary];
    
    [self.dwollaAPI getTransactionsSince:@"" withType:@"" withLimit:@"10" withSkip:@""];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testGetTransactionsSince_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dwolla.com/oauth/rest/transactions?types=money_sent&oauth_token=123456789"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               [[NSMutableArray alloc] initWithObjects: [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"1.25", @"Amount",
                                                @"8/29/2011 1:42:48 PM", @"Date",
                                                @"812-111-1111", @"DestinationId",
                                                @"Test User", @"DestinationName",
                                                @"2", @"Id",
                                                @"", @"SourceId",
                                                @"", @"SourceName",                                         
                                                @"money_sent", @"Type",
                                                @"Dwolla", @"UserType",
                                                @"processed", @"Status",
                                                @"", @"ClearingDate",                                         
                                                @"", @"Notes",                                         
                                                nil],
                                                [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 @"1.00", @"Amount",
                                                 @"8/29/2011 1:42:48 PM", @"Date",
                                                 @"812-111-1111", @"DestinationId",
                                                 @"Test User", @"DestinationName",
                                                 @"3", @"Id",
                                                 @"", @"SourceId",
                                                 @"", @"SourceName", 
                                                 @"money_sent", @"Type",
                                                 @"Dwolla", @"UserType",
                                                 @"processed", @"Status",
                                                 @"", @"ClearingDate",
                                                 @"", @"Notes",
                                                 nil], nil], @"Response", nil];
    
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest: request];
    
    NSArray *actuals = [self.dwollaAPI getTransactionsSince:@"" withType:@"money_sent" withLimit:@"" withSkip:@""];
    DwollaTransaction *actual = [actuals objectAtIndex:0];
    DwollaTransaction *actual2 = [actuals objectAtIndex:1];
    
    DwollaTransaction *expecting = [[DwollaTransaction alloc] initWithAmount:@"1.25" clearingDate:@"" date:@"8/29/2011 1:42:48 PM" destinationID:@"812-111-1111" destinationName:@"Test User" transactionID:@"2" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    DwollaTransaction *expecting2 = [[DwollaTransaction alloc] initWithAmount:@"1.00" clearingDate:@"" date:@"8/29/2011 1:42:48 PM" destinationID:@"812-111-1111" destinationName:@"Test User" transactionID:@"3" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    GHAssertEqualStrings([actual getAmount], [expecting getAmount], @"Amount expected does not match");
    GHAssertEqualStrings([actual getClearingDate], [expecting getClearingDate], @"Clearing Date expected does not match");
    GHAssertEqualStrings([actual getDate], [expecting getDate], @"Date expected does not match");
    GHAssertEqualStrings([actual getDestinationID], [expecting getDestinationID], @"Destination Id expected does not match");
    GHAssertEqualStrings([actual getDestinationName], [expecting getDestinationName], @"Destination Name expected does not match");
    GHAssertEqualStrings([actual getTransactionID], [expecting getTransactionID], @"Transaction Id expected does not match");
    GHAssertEqualStrings([actual getNotes], [expecting getNotes], @"Notes expected does not match");
    GHAssertEqualStrings([actual getSourceID], [expecting getSourceID], @"Source Id expected does not match");
    GHAssertEqualStrings([actual getSourceName], [expecting getSourceName], @"Source Name expected does not match");
    GHAssertEqualStrings([actual getStatus], [expecting getStatus], @"Status expected does not match");
    GHAssertEqualStrings([actual getType], [expecting getType], @"Type expected does not match");
    GHAssertEqualStrings([actual getUserType], [expecting getUserType], @"User Type expected does not match");
    
    GHAssertEqualStrings([actual2 getAmount], [expecting2 getAmount], @"Amount expected does not match");
    GHAssertEqualStrings([actual2 getClearingDate], [expecting2 getClearingDate], @"Clearing Date expected does not match");
    GHAssertEqualStrings([actual2 getDate], [expecting2 getDate], @"Date expected does not match");
    GHAssertEqualStrings([actual2 getDestinationID], [expecting2 getDestinationID], @"Destination Id expected does not match");
    GHAssertEqualStrings([actual2 getDestinationName], [expecting2 getDestinationName], @"Destination Name expected does not match");
    GHAssertEqualStrings([actual2 getTransactionID], [expecting2 getTransactionID], @"Transaction Id expected does not match");
    GHAssertEqualStrings([actual2 getNotes], [expecting2 getNotes], @"Notes expected does not match");
    GHAssertEqualStrings([actual2 getSourceID], [expecting2 getSourceID], @"Source Id expected does not match");
    GHAssertEqualStrings([actual2 getSourceName], [expecting2 getSourceName], @"Source Name expected does not match");
    GHAssertEqualStrings([actual2 getStatus], [expecting2 getStatus], @"Status expected does not match");
    GHAssertEqualStrings([actual2 getType], [expecting2 getType], @"Type expected does not match");
    GHAssertEqualStrings([actual2 getUserType], [expecting2 getUserType], @"User Type expected does not match");
}


//GetTransaction Test
-(void)testGetTransaction_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getTransaction:@"123"], @"No Exception was through when no AccessToken was passed in");
}
-(void)testGetTransaction_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    [[self.mockHttpRequestRepository expect] getRequest: @"https://www.dwolla.com/oauth/rest/transactions/123?oauth_token=123456789"];
    
    [self.dwollaAPI getTransaction:@"123"];
    
    [self.mockHttpRequestRepository verify];
}
-(void)testGetTransaction_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dwolla.com/oauth/rest/transactions/123?oauth_token=123456789"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                         @"1.25", @"Amount",
                                                                                         @"8/29/2011 1:42:48 PM", @"Date",
                                                                                         @"812-111-1111", @"DestinationId",
                                                                                         @"Test User", @"DestinationName",
                                                                                         @"2", @"Id",
                                                                                         @"", @"SourceId",
                                                                                         @"", @"SourceName",
                                                                                         @"money_sent", @"Type",
                                                                                         @"Dwolla", @"UserType",
                                                                                         @"processed", @"Status",
                                                                                         @"", @"ClearingDate",
                                                                                         @"", @"Notes",
                                                                                         nil], @"Response", nil];
    
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest: request];
    
    DwollaTransaction *actual = [self.dwollaAPI getTransaction:@"123"];
    
    DwollaTransaction *expecting = [[DwollaTransaction alloc] initWithAmount:@"1.25" clearingDate:@"" date:@"8/29/2011 1:42:48 PM" destinationID:@"812-111-1111" destinationName:@"Test User" transactionID:@"2" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    GHAssertEqualStrings([actual getAmount], [expecting getAmount], @"Amount expected does not match");
    GHAssertEqualStrings([actual getClearingDate], [expecting getClearingDate], @"Clearing Date expected does not match");
    GHAssertEqualStrings([actual getDate], [expecting getDate], @"Date expected does not match");
    GHAssertEqualStrings([actual getDestinationID], [expecting getDestinationID], @"Destination Id expected does not match");
    GHAssertEqualStrings([actual getDestinationName], [expecting getDestinationName], @"Destination Name expected does not match");
    GHAssertEqualStrings([actual getTransactionID], [expecting getTransactionID], @"Transaction Id expected does not match");
    GHAssertEqualStrings([actual getNotes], [expecting getNotes], @"Notes expected does not match");
    GHAssertEqualStrings([actual getSourceID], [expecting getSourceID], @"Source Id expected does not match");
    GHAssertEqualStrings([actual getSourceName], [expecting getSourceName], @"Source Name expected does not match");
    GHAssertEqualStrings([actual getStatus], [expecting getStatus], @"Status expected does not match");
    GHAssertEqualStrings([actual getType], [expecting getType], @"Type expected does not match");
    GHAssertEqualStrings([actual getUserType], [expecting getUserType], @"User Type expected does not match");
}

@end
