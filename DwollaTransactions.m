//
//  DwollaTransactions.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DwollaTransactions.h"

@implementation DwollaTransactions

-(id)initWithSuccess:(BOOL)_success 
        transactions:(NSMutableArray*)_transactions
{
    if (self)
    {
        success = _success;
        transactions = _transactions;
    }
    return self;
}

-(NSMutableArray*)getAll
{
    return transactions;
}

-(BOOL)getSuccess
{
    return success;
}

-(int)count
{
    return [transactions count];
}

-(DwollaTransaction*)getObjectAtIndex:(int)index
{
    return [transactions objectAtIndex:index];
}

-(NSString*)toString
{
    NSString* string = @"Transactions:";
    for (int i = 0; i<[transactions count]; i++) 
    {
        string = [string stringByAppendingString:[[transactions objectAtIndex:i] toString]];
    }
    return string;
}

-(BOOL) isEqualTo:(DwollaTransactions*)transactions2
{
    NSMutableArray* transactions2array = [transactions2 getAll];
    for (int i = 0; i< [transactions count]; i++) 
    {
        if (![[transactions objectAtIndex:i] isEqualTo: [transactions2array objectAtIndex:i]]) 
        {
            return NO;
        }
    }
    return YES;
}


@end
