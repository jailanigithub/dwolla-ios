//
//  DwollaOAuthTest.m
//  DwollaOAuthTest
//
//  Created by Nick Schulze on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaOAuthTest.h"
#import "DwollaAPI.h"
#import <OCMock/OCMock.h>


@implementation DwollaOAuthTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBasicAccountInfo
{
    id mockService = [OCMockObject mockForClass:[DwollaAPI class]];
    [[[mockService expect] andReturn:[[DwollaUser alloc] initWithUserID:@"812-570-5285" name:@"Nick Schulze" city:@"Ames" state:@"IA" latitude:@"0" longitude:@"0" type:@"Personal"]] getBasicInfoWithAccountID:@"812-570-5285"];
    
    [mockService verify];
}


@end
