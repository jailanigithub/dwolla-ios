//
//  SampleTest.m
//  TestApp
//
//  Created by Mark Wolfe on 14/06/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>


@interface SampleTest : GHTestCase {}
@end


@implementation SampleTest

- (void)testSomeStringsEqualEachOther{
    
    NSString *someString = @"Have me some objective c testing";
    
    GHAssertEquals(@"Have me some objective c testing", someString, @"The strings should match bro");
}

@end