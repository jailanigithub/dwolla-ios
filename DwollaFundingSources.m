//
//  DwollaFundingSources.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaFundingSources.h"

@implementation DwollaFundingSources

-(id)initWithSuccess:(BOOL)_success 
            sources:(NSMutableArray*)_sources
{
    if (self) 
    {
        success = _success;
        sources = _sources;
    }
    return self;
}

-(BOOL)getSuccess
{
    return success;
}

-(NSMutableArray*)getAll
{
    return sources;
}

-(NSMutableArray*)getAlphabetized:(NSString *)direction
{
    if ([direction isEqualToString:@"DESC"]) 
    {
        [sources sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            DwollaFundingSource* one = (DwollaFundingSource*) obj1;
            DwollaFundingSource* two = (DwollaFundingSource*) obj2;
            
            return [[one getName] compare:[two getName]];
        }];
    }
    else
    {
        [sources sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            DwollaFundingSource* one = (DwollaFundingSource*) obj1;
            DwollaFundingSource* two = (DwollaFundingSource*) obj2;
            
            return -1*[[one getName] compare:[two getName]];
        }];     
    }
    
    return sources;
}

-(int)count
{
    return [sources count];
}

-(DwollaFundingSource*)getObjectAtIndex:(int)index
{
    return [sources objectAtIndex:index];
}

-(NSString*)toString
{
    NSString* string = @"Funding Sources:";
    for (int i = 0; i<[sources count]; i++) 
    {
        string = [string stringByAppendingString:[[sources objectAtIndex:i] toString]];
    }
    return string;
}

-(BOOL) isEqualTo:(DwollaFundingSources*)sources2
{
    NSMutableArray* sources2array = [sources2 getAll];
    for (int i = 0; i< [sources count]; i++) 
    {
        if (![[sources objectAtIndex:i] isEqualTo: [sources2array objectAtIndex:i]]) 
        {
            return NO;
        }
    }
    return YES;
}

@end
