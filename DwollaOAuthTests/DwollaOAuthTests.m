//
//  DwollaOAuthTests.m
//  DwollaOAuthTests
//
//  Created by Nick Schulze on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaOAuthTests.h"
#import "DwollaAPI.h"
#import "OCMock.h"


@implementation DwollaOAuthTests

-(void)setUp
{
    [super setUp];
    [DwollaAPI setTest:YES];

    // Set-up code here.
}

-(void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void)testBalance
{
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":16.3200}";
    [DwollaAPI setResult:data];
    NSString* balance = [DwollaAPI getBalance];
    NSAssert([balance isEqualToString:@"16.32"], [@"Balances not equal. Balance was: " stringByAppendingString:balance]);
}

-(void)testBasicAccountInfo
{
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"Id\":\"812-570-5285\",\"Latitude\":41.584546,\"Longitude\":-93.634167,\"Name\": \"Nick Schulze\"}}";
    [DwollaAPI setResult:data];
    DwollaUser *user = [DwollaAPI getBasicInfoWithAccountID:@"812-570-5285"];
    DwollaUser *verify = [[DwollaUser alloc] initWithUserID:@"812-570-5285" name:@"Nick Schulze" city:@"Ames" state:@"IA" latitude:@"0" longitude:@"0" type:@"Personal"];
    NSString* userString = [user toString];
    NSString* verifyString = [verify toString];
    NSString* failString = [NSString stringWithFormat:@"Failed. User:%@ Verify:%@", userString, verifyString];
    NSAssert([user isEqualTo:verify], failString);
}

-(void)testBasicAccountInfoIDEmpty
{
    @try
    {
        [DwollaAPI getBasicInfoWithAccountID:@""];  
    }
    @catch (NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"accountID is either nil or empty"])
        {
            NSAssert(1==1, @"Passed");
            return; 
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
}

-(void)testAccountInfo
{
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"City\":\"Des Moines\",\"Id\":\"812-570-5285\",\"Latitude\":41.584546,\"Longitude\":-93.634167,\"Name\":\"Nick Schulze\",\"State\":\"Iowa\",\"Type\":\"Personal\"}}";
    [DwollaAPI setResult:data];
    DwollaUser *user = [DwollaAPI getAccountInfo];
    DwollaUser *verify = [[DwollaUser alloc] initWithUserID:@"812-570-5285" name:@"Nick Schulze" city:@"Ames" state:@"IA" latitude:@"0" longitude:@"0" type:@"Personal"];
    NSString* userString = [user toString];
    NSString* verifyString = [verify toString];
    NSString* failString = [NSString stringWithFormat:@"Failed. User:%@ Verify:%@", userString, verifyString];
    NSAssert([user isEqualTo:verify], failString);
}

-(void)testFundingSources
{    
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Id\":\"zA+3iWesTvqgFjl92AusIA==\",\"Name\":\"Bank of the West - Checking\",\"Type\":\"Checking\",\"Verified\":\"true\"}]}";
    [DwollaAPI setResult:data];
    DwollaFundingSources *sources = [DwollaAPI getFundingSources];
    
    DwollaFundingSource *bankOfWest = [[DwollaFundingSource alloc] initWithSourceID:@"zA+3iWesTvqgFjl92AusIA==" name:@"Bank of the West - Checking" type:@"Checking" verified:@"true"];
    NSMutableArray* funding = [[NSMutableArray alloc] initWithObjects:bankOfWest, nil];
    DwollaFundingSources *verify = [[DwollaFundingSources alloc] initWithSuccess:YES sources:funding];
    
    NSString* sourcesString = [sources toString];
    NSString* verifyString = [verify toString];
    NSString* failString = [NSString stringWithFormat:@"Failed. User:%@ Verify:%@", sourcesString, verifyString];
    NSAssert([sources isEqualTo:verify], failString);
}

-(void)testFundingSource
{
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"Id\":\"zA+3iWesTvqgFjl92AusIA==\",\"Name\":\"Bank of the West - Checking\",\"Type\":\"Checking\",\"Verified\":\"true\"}}";
    [DwollaAPI setResult:data];
    DwollaFundingSource *source = [DwollaAPI getFundingSource:@"zA+3iWesTvqgFjl92AusIA=="];
    
    DwollaFundingSource *verify = [[DwollaFundingSource alloc] initWithSourceID:@"zA+3iWesTvqgFjl92AusIA==" name:@"Bank of the West - Checking" type:@"Checking" verified:@"true"];
    
    NSString* sourceString = [source toString];
    NSString* verifyString = [verify toString];
    NSString* failString = [NSString stringWithFormat:@"Failed. User:%@ Verify:%@", sourceString, verifyString];
    NSAssert([source isEqualTo:verify], failString);
}

-(void)testFundingSourceIDNil
{
    @try
    {
      [DwollaAPI getFundingSource:nil];  
    }
    @catch (NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"sourceID is either nil or empty"])
        {
            NSAssert(1==1, @"Passed");
            return; 
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }

    NSAssert(1!=1, @"Error not thrown.");
}

-(void)testGetTransactions
{
     
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Amount\": 1.25,\"Date\": \"8/29/2011 1:42:48 PM\",\"DestinationId\":\"812-111-1111\",\"DestinationName\": \"Test User\",\"Id\": 2,\"SourceId\": \"\",\"SourceName\": \"\",\"Type\":\"money_sent\",\"UserType\":\"Dwolla\",\"Status\":\"processed\",\"ClearingDate\":\"\",\"Notes\":\"\"},{\"Amount\": 1.25,\"Date\":\"8/29/2011 1:17:35 PM\",\"DestinationId\": \"\",\"DestinationName\":\"\",\"Id\": 1,\"SourceId\":\"812-111-1111\",\"SourceName\":\"Test User\",\"Type\":\"money_received\",\"UserType\":\"Dwolla\",\"Status\":\"processed\",\"ClearingDate\":\"\",\"Notes\":\"Thank you for lunch!\"}]}";
    [DwollaAPI setResult:data];
    DwollaTransactions *transactions = [DwollaAPI getTransactionsSince:@"" limit:@"" skip:@""];
    DwollaTransaction *one = [[DwollaTransaction alloc] initWithAmount:@"1.25" clearingDate:@"" date:@"8/29/2011 1:42:48 PM" destinationID:@"812-111-1111" destinationName:@"Test User" transactionID:@"2" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    DwollaTransaction *two = [[DwollaTransaction alloc] initWithAmount:@"1.25" clearingDate:@"" date:@"8/29/2011 1:17:35 PM" destinationID:@"" destinationName:@"Test User" transactionID:@"1" notes:@"Thank you for lunch!" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_recieved" userType:@"Dwolla"];
    NSMutableArray* test = [[NSMutableArray alloc] initWithObjects:one, two, nil];
    DwollaTransactions* transactions2 = [[DwollaTransactions alloc] initWithSuccess:YES transactions:test];
    
    NSString* oneString = [transactions toString];
    NSString* twoString = [transactions2 toString];
    NSString* failString = [NSString stringWithFormat:@"Failed. One:%@ Two:%@", oneString, twoString];
    NSAssert([transactions isEqualTo:transactions2], failString);
}

-(void)testGetTransaction
{
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"Amount\": 1.25,\"Date\": \"8/29/2011 1:42:48 PM\",\"DestinationId\":\"812-111-1111\",\"DestinationName\": \"Test User\",\"Id\": 2,\"SourceId\": \"\",\"SourceName\": \"\",\"Type\":\"money_sent\",\"UserType\":\"Dwolla\",\"Status\":\"processed\",\"ClearingDate\":\"\",\"Notes\":\"\"}}";
    [DwollaAPI setResult:data];
    DwollaTransaction *one = [DwollaAPI getTransaction:@"1234"];
    DwollaTransaction *two = [[DwollaTransaction alloc] initWithAmount:@"1.25" clearingDate:@"" date:@"8/29/2011 1:42:48 PM" destinationID:@"812-111-1111" destinationName:@"Test User" transactionID:@"2" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    NSString* oneString = [one toString];
    NSString* twoString = [two toString];
    NSString* failString = [NSString stringWithFormat:@"Failed. One:%@ Two:%@", oneString, twoString];
    NSAssert([one isEqualTo:two], failString);
}

-(void)testGetTransactionIDEmpty
{
    @try
    {
        [DwollaAPI getTransaction:@""];  
    }
    @catch (NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"transactionID is either nil or empty"])
        {
            NSAssert(1==1, @"Passed");
            return; 
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
}

-(void)testGetTransactionStats
{
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"TransactionsCount\": 5,\"TransactionsTotal\": 116.92}}";
    [DwollaAPI setResult:data];
    DwollaTransactionStats *stats = [DwollaAPI getTransactionStats:nil end:nil];
    DwollaTransactionStats *stats2 = [[DwollaTransactionStats alloc] initWithSuccess:YES count:@"5" total:@"116.92"];
    NSString* oneString = [stats toString];
    NSString* twoString = [stats2 toString];
    NSString* failString = [NSString stringWithFormat:@"Failed. One:%@ Two:%@", oneString, twoString];
    NSAssert([stats isEqualTo:stats2], failString);
}


-(void)testRegisterUser
{
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":{\"City\":\"Des Moines\",\"Id\":\"812-570-5285\",\"Latitude\":41.584546,\"Longitude\":-93.634167,\"Name\":\"Nick Schulze\",\"State\":\"Iowa\",\"Type\":\"Personal\"}}";
    [DwollaAPI setResult:data];
    DwollaUser* user = [DwollaAPI registerUserWithEmail:@"12345" password:@"12345" pin:@"****" firstName:@"12345" lastName:@"12345" address:@"12345" address2:@"12345" city:@"12345" state:@"12345" zip:@"12345" phone:@"12345" birthDate:@"12345" type:@"Personal" organization:@"12345" ein:@"12345" acceptTerms:YES];
    DwollaUser *verify = [[DwollaUser alloc] initWithUserID:@"812-570-5285" name:@"Nick Schulze" city:@"Ames" state:@"IA" latitude:@"0" longitude:@"0" type:@"Personal"];
    NSString* userString = [user toString];
    NSString* verifyString = [verify toString];
    NSString* failString = [NSString stringWithFormat:@"Failed. User:%@ Verify:%@", userString, verifyString];
    NSAssert([user isEqualTo:verify], failString);
}

-(void)testRegisterUserPININotFour
{
    @try
    {
        [DwollaAPI registerUserWithEmail:@"12345" password:@"12345" pin:@"*****" firstName:@"12345" lastName:@"12345" address:@"12345" address2:@"12345" city:@"12345" state:@"12345" zip:@"12345" phone:@"12345" birthDate:@"12345" type:@"Personal" organization:@"12345" ein:@"12345" acceptTerms:YES];    
    }
    @catch (NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"pin isn't four characters"])
        {
            NSAssert(1==1, @"Passed");
            return; 
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
}

-(void)testRegisterUserEmailNil
{
    @try
    {
        [DwollaAPI registerUserWithEmail:nil password:@"12345" pin:@"12345" firstName:@"12345" lastName:@"12345" address:@"12345" address2:@"12345" city:@"12345" state:@"12345" zip:@"12345" phone:@"12345" birthDate:@"12345" type:@"Personal" organization:@"12345" ein:@"12345" acceptTerms:YES];  
    }
    @catch (NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"either email, password, pin, first, last, address, city, state, zip, phone, or date of birth is nil or empty"])
        {
            NSAssert(1==1, @"Passed");
            return; 
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
}

-(void)testRegisterUserPasswordEmpty
{
    @try
    {
        [DwollaAPI registerUserWithEmail:@"12345" password:@"" pin:@"12345" firstName:@"12345" lastName:@"12345" address:@"12345" address2:@"12345" city:@"12345" state:@"12345" zip:@"12345" phone:@"12345" birthDate:@"12345" type:@"Personal" organization:@"12345" ein:@"12345" acceptTerms:YES];   
    }
    @catch (NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"either email, password, pin, first, last, address, city, state, zip, phone, or date of birth is nil or empty"])
        {
            NSAssert(1==1, @"Passed");
            return; 
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
}

-(void)testRegisterUserFirstNil
{
    @try
    {
        [DwollaAPI registerUserWithEmail:@"12345" password:@"12345" pin:@"12345" firstName:nil lastName:@"12345" address:@"12345" address2:@"12345" city:@"12345" state:@"12345" zip:@"12345" phone:@"12345" birthDate:@"12345" type:@"Personal" organization:@"12345" ein:@"12345" acceptTerms:YES];   
    }
    @catch (NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"either email, password, pin, first, last, address, city, state, zip, phone, or date of birth is nil or empty"])
        {
            NSAssert(1==1, @"Passed");
            return; 
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
}

-(void)testGetContacts
{
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Name\":\"Ben Facebook Test\",\"Id\":\"12345\",\"Type\":\"Facebook\",\"Image\":\"https://graph.facebook.com/12345/picture?type=square\"},{\"Name\": \"Ben Dwolla Test\",\"Id\":\"23456\",\"Type\":\"Dwolla\",\"Image\": \"https://www.dwolla.com/avatar.aspx?u=812-111-1111\"}]}";
    [DwollaAPI setResult:data];
    DwollaContacts *contacts = [DwollaAPI getContactsByName:nil types:nil limit:nil];
    DwollaContact* one = [[DwollaContact alloc] initWithUserID:@"12345" name:@"Ben Facebook Test" image:@"https://graph.facebook.com/12345/picture?type=square" city:@"" state:@"" type:@"Facebook" latitude:@"" longitude:@"" address:@"" postal:@""];
    DwollaContact* two = [[DwollaContact alloc] initWithUserID:@"23456" name:@"Ben Dwolla Test" image:@"https://www.dwolla.com/avatar.aspx?u=812-111-1111" city:@"" state:@"" type:@"Dwolla" latitude:@"" longitude:@"" address:@"" postal:@""];
    NSMutableArray* contactsArray = [[NSMutableArray alloc] initWithObjects:one, two, nil];
    DwollaContacts* contacts2 = [[DwollaContacts alloc] initWithSuccess:YES contacts:contactsArray];
    
    NSString* oneString = [contacts toString];
    NSString* twoString = [contacts2 toString];
    NSString* failString = [NSString stringWithFormat:@"Failed. One:%@ Two:%@", oneString, twoString];
    NSAssert([contacts isEqualTo:contacts2], failString);
}

-(void)testGetNearby
{
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":[{\"Address\": \"111 West 5th St. Suite A\",\"City\": \"Des Moines\",\"Group\": \"812-111-2222\",\"Id\": \"812-111-1111\",\"Image\": \"https://www.dwolla.com/avatar.aspx?u=812-111-1111\",\"Latitude\": 41.5852257,\"Longitude\": -93.6245059,\"Name\": \"Test Spot 1\",\"PostalCode\": \"50309\",\"State\": \"IA\"},{\"Address\": \"111 West 5th St. Suite B\",\"City\": \"Des Moines\",\"Group\":\"812-111-1111\",\"Id\": \"812-111-2222\",\"Image\": \"https://www.dwolla.com/avatar.aspx?u=812-111-2222\",\"Latitude\": 41.5852257,\"Longitude\": -93.6245059,\"Name\": \"Test Spot 2\",\"PostalCode\": \"50309\",\"State\": \"IA\"}]}";
    [DwollaAPI setResult:data];
    DwollaContacts *contacts = [DwollaAPI getNearbyWithLatitude:@"0" Longitude:@"0" Limit:@"1" Range:@"10"];
    DwollaContact* one = [[DwollaContact alloc] initWithUserID:@"812-111-1111" name:@"Test Spot 1" image:@"https://graph.facebook.com/12345/picture?type=square" city:@"" state:@"" type:@"" latitude:@"41.5852257" longitude:@"-93.6245059" address:@"111 West 5th St. Suite B" postal:@"50309"];
    DwollaContact* two = [[DwollaContact alloc] initWithUserID:@"812-111-2222" name:@"Test Spot 2" image:@"https://www.dwolla.com/avatar.aspx?u=812-111-1111" city:@"" state:@"" type:@"" latitude:@"41.5852257" longitude:@"-93.6245059" address:@"111 West 5th St. Suite B" postal:@"50309"];
    NSMutableArray* contactsArray = [[NSMutableArray alloc] initWithObjects:one, two, nil];
    DwollaContacts* contacts2 = [[DwollaContacts alloc] initWithSuccess:YES contacts:contactsArray];
    
    NSString* oneString = [contacts toString];
    NSString* twoString = [contacts2 toString];
    NSString* failString = [NSString stringWithFormat:@"Failed. One:%@ Two:%@", oneString, twoString];
    NSAssert([contacts isEqualTo:contacts2], failString);
}

-(void)testGetNearbyLongEmpty
{
    @try
    {
        [DwollaAPI getNearbyWithLatitude:nil Longitude:@"" Limit:@"1" Range:@"1"];
    }
    @catch (NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"latitude or longitude is either nil or empty"])
        {
            NSAssert(1==1, @"Passed");
            return; 
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
}

-(void)testGetNearbyLatNil
{
    @try
    {
        [DwollaAPI getNearbyWithLatitude:nil Longitude:@"0" Limit:@"1" Range:@"1"];
    }
    @catch (NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"latitude or longitude is either nil or empty"])
        {
            NSAssert(1==1, @"Passed");
            return; 
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
}

-(void)testRequestMoney
{
    
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":12345}";
    [DwollaAPI setResult:data];  
    
    NSString* request = [DwollaAPI requestMoneyWithPIN:@"****" sourceID:@"1" sourceType:@"1" amount:@"1" facilitatorAmount:@"1" notes:@"1"];
      NSAssert([request isEqualToString:@"12345"], [@"ID's not equal. ID was: " stringByAppendingString:request]);
}

-(void)testRequestMoneyAmountEmpty
{
    @try
    {
        [DwollaAPI requestMoneyWithPIN:@"****" sourceID:@"1" sourceType:@"1" amount:@"" facilitatorAmount:@"1" notes:@"1"];
    }
    @catch(NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"amount is either nil or empty"]) 
        {
            NSAssert(1==1, @"Passed");
            return;
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
    
}

-(void)testRequestMoneySourceIDEmpty
{
    @try
    {
        [DwollaAPI requestMoneyWithPIN:@"****" sourceID:@"" sourceType:@"1" amount:@"1" facilitatorAmount:@"1" notes:@"1"];
    }
    @catch(NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"sourceID is either nil or empty"]) 
        {
            NSAssert(1==1, @"Passed");
            return;
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
    
}

-(void)testRequestMoneyPINNil
{
    @try
    {
        [DwollaAPI requestMoneyWithPIN:nil sourceID:@"1" sourceType:@"1" amount:@"1" facilitatorAmount:@"1" notes:@"1"];
    }
    @catch(NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"pin is either nil or empty or not four characters"]) 
        {
            NSAssert(1==1, @"Passed");
            return;
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
    
}

-(void)testRequestMoneyPINNotFour
{
    @try
    {
        [DwollaAPI requestMoneyWithPIN:@"***" sourceID:@"1" sourceType:@"1" amount:@"1" facilitatorAmount:@"1" notes:@"1"];
    }
    @catch(NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"pin is either nil or empty or not four characters"]) 
        {
            NSAssert(1==1, @"Passed");
            return;
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
    
}


-(void)testSendMoney
{
    NSString* data = @"{\"Success\":true,\"Message\":\"Success\",\"Response\":12345}";
    [DwollaAPI setResult:data];  
    
    NSString* send = [DwollaAPI sendMoneyWithPIN:@"****" destinationID:@"1" destinationType:@"1" amount:@"1" facilitatorAmount:@"1" assumeCosts:@"1" notes:@"1" fundingSourceID:@"1"];
    
    NSAssert([send isEqualToString:@"12345"], [@"ID's not equal. ID was: " stringByAppendingString:send]);
}

-(void)testSendMoneyAmountEmpty
{
    @try
    {
    [DwollaAPI sendMoneyWithPIN:@"****" destinationID:@"1" destinationType:@"1" amount:@"" facilitatorAmount:@"1" assumeCosts:@"1" notes:@"1" fundingSourceID:@"1"];
    }
    @catch(NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"amount is either nil or empty"]) 
        {
            NSAssert(1==1, @"Passed");
            return;
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");

}

-(void)testSendMoneyDestinationIDEmpty
{
    @try
    {
        [DwollaAPI sendMoneyWithPIN:@"****" destinationID:@"" destinationType:@"1" amount:@"1" facilitatorAmount:@"1" assumeCosts:@"1" notes:@"1" fundingSourceID:@"1"];
    }
    @catch(NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"destinationID is either nil or empty"]) 
        {
            NSAssert(1==1, @"Passed");
            return;
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
    
}

-(void)testSendMoneyPINNil
{
    @try
    {
        [DwollaAPI sendMoneyWithPIN:nil destinationID:@"1" destinationType:@"1" amount:@"1" facilitatorAmount:@"1" assumeCosts:@"1" notes:@"1" fundingSourceID:@"1"];
    }
    @catch(NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"pin is either nil or empty or not four characters"]) 
        {
            NSAssert(1==1, @"Passed");
            return;
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
    
}

-(void)testSendMoneyPINNotFour
{
    @try
    {
        [DwollaAPI sendMoneyWithPIN:@"*****" destinationID:@"1" destinationType:@"1" amount:@"1" facilitatorAmount:@"1" assumeCosts:@"1" notes:@"1" fundingSourceID:@"1"];
    }
    @catch(NSException* e) 
    {
        if ([[e name]isEqualToString:@"INVALID_PARAMETER_EXCEPTION"] && [[e reason] isEqualToString:@"pin is either nil or empty or not four characters"]) 
        {
            NSAssert(1==1, @"Passed");
            return;
        }
        else
        {
            NSString* fail = [NSString stringWithFormat:@"%@: %@", [e name], [e reason]];
            NSAssert(1!=1, fail);
            return;
        }
    }
    
    NSAssert(1!=1, @"Error not thrown.");
    
}
@end
