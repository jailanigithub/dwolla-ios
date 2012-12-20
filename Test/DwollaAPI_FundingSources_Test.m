//
//  Created by James Armstead on 12/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h>
#import <DwollaOAuthLib/DwollaAPI.h>
#import "DwollaAPI_Base_Test.h"

@interface DwollaAPI_FundingSources_Tests : DwollaAPI_Base_Test {}
@end

@implementation DwollaAPI_FundingSources_Tests

-(void)testFundingSources_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getFundingSources], @"No Exception was through when no AccessToken was passed in");
}

-(void)testFundingSources_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    [[self.mockHttpRequestRepository expect] getRequest:@"https://www.dwolla.com/oauth/rest/fundingsources?oauth_token=123456789"];
    
    [self.dwollaAPI getFundingSources];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testFundingSources_WithValidData_ShouldReturnBalance
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSString* expectedId = @"TVmMwlKz1z6HmOK1np8NFA==";
    NSString* expectedName = @"Donations Collection Fund - Savings";
    NSString* expectedType = @"Savings";
    NSString* expectedVerified = @"true";
    
    [[[self.mockHttpRequestRepository stub] andReturn:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                       @"true", @"Success",
                                                       [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                                                         expectedId, @"Id",
                                                                                         expectedName, @"Name",
                                                                                         expectedType, @"Type",
                                                                                         expectedVerified, @"Verified",
                                                                                         nil], nil], @"Response", nil]] getRequest:@"https://www.dwolla.com/oauth/rest/fundingsources?oauth_token=123456789"];
    
    NSArray* fundingSources = [self.dwollaAPI getFundingSources];
    
    DwollaFundingSource *fundingSource = [fundingSources objectAtIndex:0];
    
    GHAssertEqualStrings([fundingSource getSourceID], expectedId, @"Id expected does not match");
    GHAssertEqualStrings([fundingSource getName], expectedName, @"Name expected does not match");
    GHAssertEqualStrings([fundingSource getType], expectedType, @"Type expected does not match");
    GHAssertTrue([fundingSource isVerified], @"Verified expected does not match");
}

@end
